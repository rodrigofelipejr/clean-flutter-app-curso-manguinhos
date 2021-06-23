import 'package:get/get.dart';

import '../../../ui/pages/pages.dart';
import '../../../ui/helpers/helpers.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

class GetXSurveyResultPresenter extends GetxController implements SurveyResultPresenter {
  final LoadSurveyResult loadSurveyResult;
  final String surveyId;

  GetXSurveyResultPresenter({
    required this.loadSurveyResult,
    required this.surveyId,
  });

  var _isLoading = RxBool(true);
  var _isSessionExpired = RxBool(false);
  var _surveyResult = Rxn<SurveyResultViewModel>();

  Stream<bool> get isLoadingStream => _isLoading.subject.stream;
  Stream<bool> get isSessionExpiredStream => _isSessionExpired.subject.stream;
  Stream<SurveyResultViewModel?> get surveyResultStream => _surveyResult.subject.stream;

  @override
  Future<void> loadData() async {
    try {
      _isLoading.value = true;
      final surveyResult = await loadSurveyResult.loadBySurvey(surveyId: surveyId);
      _surveyResult.value = SurveyResultViewModel(
        surveysId: surveyResult.surveysId,
        question: surveyResult.question,
        answers: surveyResult.answers
            .map(
              (answer) => SurveyAnswerViewModel(
                image: answer.image,
                answer: answer.answer,
                isCurrentAnswer: answer.isCurrentAnswer.toLowerCase() == 'true',
                percent: '${answer.percent}%',
              ),
            )
            .toList(),
      );
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied)
        _isSessionExpired.value = true;
      else
        _surveyResult.subject.addError(UiError.unexpected.description);
      //FIXME - refactor
      print(UiError.unexpected.description);
    } finally {
      _isLoading.value = false;
    }
  }
}
