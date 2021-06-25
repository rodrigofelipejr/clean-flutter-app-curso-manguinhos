import '../../data/usecases/usecases.dart';
import '../../domain/entities/survey_entity.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

class RemoteLoadSurveysWithLocalFallback implements LoadSurveys {
  final RemoteLoadSurveys remoteLoadSurveys;
  final LocalLoadSurveys localLoadSurveys;

  RemoteLoadSurveysWithLocalFallback({
    required this.remoteLoadSurveys,
    required this.localLoadSurveys,
  });

  @override
  Future<List<SurveyEntity>> load() async {
    late List<SurveyEntity> surveys;
    try {
      surveys = await remoteLoadSurveys.load();
      await localLoadSurveys.save(surveys);
    } catch (error) {
      //NOTE - Em domain layer já tratamos para sempre retornar um DomainError, mas por precaução
      if (error == DomainError.accessDenied) rethrow;
      await localLoadSurveys.validate();
      surveys = await localLoadSurveys.load();
    }
    return surveys;
  }
}
