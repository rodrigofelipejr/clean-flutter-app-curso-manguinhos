import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../ui/pages/pages.dart';
import '../../ui/helpers/helpers.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

class GetXSurveysPresenter extends GetxController implements SurveysPresenter {
  final LoadSurveys loadSurveys;

  GetXSurveysPresenter({required this.loadSurveys});

  var _isLoading = RxBool(true);
  var _surveys = RxList<SurveyViewModel>([]);

  Stream<bool> get isLoadingStream => _isLoading.subject.stream;
  Stream<List<SurveyViewModel>> get surveysStream => _surveys.subject.stream;

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
      //FIXME - refactor
      _surveys.subject.addError(UiError.unexpected.description);
      print(UiError.unexpected.description);
    } finally {
      _isLoading.value = false;
    }
  }
}
