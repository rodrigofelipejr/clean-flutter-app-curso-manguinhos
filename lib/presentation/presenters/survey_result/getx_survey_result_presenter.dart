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
  final SaveSurveyResult saveSurveyResult;
  final String surveyId;

  GetXSurveyResultPresenter({
    required this.loadSurveyResult,
    required this.saveSurveyResult,
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
        surveysId: surveyResult.surveyId,
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
        //FIXME - refactor
        _surveyResult.subject.addError(UiError.unexpected.description);
      print(UiError.unexpected.description);
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> save({required String answer}) async {
    try {
      isLoading = true;
      final surveyResult = await saveSurveyResult.save(answer: answer);
      _surveyResult.value = SurveyResultViewModel(
        surveysId: surveyResult.surveyId,
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
    } catch (error) {
      if (error == DomainError.accessDenied)
        isSessionExpired = true;
      else
        //FIXME - refactor
        _surveyResult.subject.addError(UiError.unexpected.description);
      print(UiError.unexpected.description);
    } finally {
      isLoading = false;
    }
  }
}
