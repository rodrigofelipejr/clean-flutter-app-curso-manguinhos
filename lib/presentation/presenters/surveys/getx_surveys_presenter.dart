import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../shared/routes/routes.dart';
import '../../../ui/pages/pages.dart';
import '../../../ui/helpers/helpers.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

class GetXSurveysPresenter extends GetxController implements SurveysPresenter {
  final LoadSurveys loadSurveys;

  GetXSurveysPresenter({required this.loadSurveys});

  var _isLoading = RxBool(true);
  var _isSessionExpired = RxBool(false);
  var _surveys = RxList<SurveyViewModel>([]);
  var _navigateTo = RxnString();

  Stream<bool> get isLoadingStream => _isLoading.subject.stream;
  Stream<bool> get isSessionExpiredStream => _isSessionExpired.subject.stream;
  Stream<List<SurveyViewModel>> get surveysStream => _surveys.subject.stream;
  Stream<String?> get navigateToStream => _navigateTo.stream;

  @override
  Future<void> loadData() async {
    try {
      _isLoading.value = true;
      final surveys = await loadSurveys.load();
      _surveys.value = surveys
          .map((survey) => SurveyViewModel(
                id: survey.id,
                question: survey.question,
                date: DateFormat('dd MM yyyy').format(survey.dateTime),
                didAnswer: survey.didAnswer,
              ))
          .toList();
    } on DomainError {
      _surveys.subject.addError(UiError.unexpected.description);
      //FIXME - refactor
      print(UiError.unexpected.description);
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void goToSurveyResult(String surveyId) {
    _navigateTo.value = '${AppRoutes.surveyResult}/$surveyId';
  }
}
