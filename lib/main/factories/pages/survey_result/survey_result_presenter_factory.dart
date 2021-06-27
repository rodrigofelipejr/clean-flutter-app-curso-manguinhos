import '../../../factories/factories.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

SurveyResultPresenter makeGetxSurveyResultPresenter(String surveyId) {
  return GetXSurveyResultPresenter(
    loadSurveyResult: makeRemoteLoadSurveyResultWithLocalFallback(surveyId), //NOTE - Use case
    saveSurveyResult: makeRemoteSaveSurveyResult(surveyId),
    surveyId: surveyId,
  );
}
