import '../../../factories/factories.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

SurveyResultPresenter makeGetxSurveyResultPresenter(String surveyId) {
  return GetXSurveyResultPresenter(
    loadSurveyResult: makeRemoteLoadSurveyResult(surveyId), //NOTE - Use case
    surveyId: surveyId,
  );
}
