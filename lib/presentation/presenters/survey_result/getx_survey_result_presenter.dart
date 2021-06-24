import 'package:get/get.dart';

import '../../../ui/pages/pages.dart';
import '../../../ui/helpers/helpers.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../presentation/mixins/mixins.dart';

class GetXSurveyResultPresenter extends GetxController
    with LoadingManager, SessionManager
    implements SurveyResultPresenter {
  final LoadSurveyResult loadSurveyResult;
  final String surveyId;

  GetXSurveyResultPresenter({
    required this.loadSurveyResult,
    required this.surveyId,
  });

  var _surveyResult = Rxn<SurveyResultViewModel>();

  Stream<SurveyResultViewModel?> get surveyResultStream => _surveyResult.subject.stream;

  @override
  Future<void> loadData() async {
    try {
      isLoading = true;
      final surveyResult = await loadSurveyResult.loadBySurvey(surveyId: surveyId);
      _surveyResult.value = SurveyResultViewModel(
        surveysId: surveyResult.surveysId,
        question: surveyResult.question,
        answers: surveyResult.answers
            .map(
              (answer) => SurveyAnswerViewModel(
                image: answer.image,
                answer: answer.answer,
                isCurrentAnswer: answer.isCurrentAnswer,
                percent: '${answer.percent}%',
              ),
            )
            .toList(),
      );
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied)
        isSessionExpired = true;
      else
        _surveyResult.subject.addError(UiError.unexpected.description);
      //FIXME - refactor
      print(UiError.unexpected.description);
    } finally {
      isLoading = false;
    }
  }
}
