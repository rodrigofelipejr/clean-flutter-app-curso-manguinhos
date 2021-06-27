import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../presentation/mixins/mixins.dart';
import '../../../shared/routes/routes.dart';
import '../../../ui/pages/pages.dart';
import '../../../ui/helpers/helpers.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

class GetXSurveysPresenter extends GetxController
    with LoadingManager, SessionManager, NavigationManager
    implements SurveysPresenter {
  final LoadSurveys loadSurveys;

  GetXSurveysPresenter({required this.loadSurveys});

  var _surveys = RxList<SurveyViewModel>([]);

  Stream<List<SurveyViewModel>> get surveysStream => _surveys.subject.stream;

  @override
  Future<void> loadData() async {
    try {
      isLoading = true;
      final surveys = await loadSurveys.load();
      _surveys.subject.add(surveys
          .map((survey) => SurveyViewModel(
                id: survey.id,
                question: survey.question,
                date: DateFormat('dd MM yyyy').format(survey.dateTime),
                didAnswer: survey.didAnswer,
              ))
          .toList());
      print(surveys);
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied)
        isSessionExpired = true;
      else
        //FIXME - refactor
        _surveys.subject.addError(UiError.unexpected.description);
      print(UiError.unexpected.description);
    } finally {
      isLoading = false;
    }
  }

  @override
  void goToSurveyResult(String surveyId) {
    navigateTo = '${AppRoutes.surveyResult}/$surveyId';
  }
}
