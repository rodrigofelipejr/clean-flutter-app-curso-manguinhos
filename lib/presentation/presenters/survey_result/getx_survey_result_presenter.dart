import 'package:get/get.dart';

import '../../../ui/pages/pages.dart';
import '../../../ui/helpers/helpers.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../presentation/mixins/mixins.dart';
import '../../../presentation/helpers/helpers.dart';

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
    showResultOnAction(() => loadSurveyResult.loadBySurvey(surveyId: surveyId));
  }

  @override
  Future<void> save({required String answer}) async {
    showResultOnAction(() => saveSurveyResult.save(answer: answer));
  }

  Future<void> showResultOnAction(Future<SurveyResultEntity> action()) async {
    try {
      isLoading = true;
      final surveyResult = await action();
      _surveyResult.subject.add(surveyResult.toViewModel());
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
