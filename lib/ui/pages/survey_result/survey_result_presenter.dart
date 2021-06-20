import '../../../ui/pages/survey_result/survey_result.dart';

abstract class SurveyResultPresenter {
  Future<void> loadData();
  Stream<bool> get isLoadingStream;
  Stream<SurveyResultViewModel> get surveyResultStream;
}
