import '../../domain/helpers/helpers.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import '../../../data/usecases/usecases.dart';

class RemoteLoadSurveyResultWithLocalFallback implements LoadSurveyResult {
  final RemoteLoadSurveyResult remote;
  final LocalLoadSurveyResult local;

  RemoteLoadSurveyResultWithLocalFallback({
    required this.remote,
    required this.local,
  });

  @override
  Future<SurveyResultEntity> loadBySurvey({String? surveyId}) async {
    late SurveyResultEntity surveyResult;
    try {
      surveyResult = await remote.loadBySurvey(surveyId: surveyId);
      await local.save(surveyResult);
    } catch (error) {
      if (error == DomainError.accessDenied) rethrow;
      await local.validate(surveyId!);
      surveyResult = await local.loadBySurvey(surveyId: surveyId);
    }
    return surveyResult;
  }
}
