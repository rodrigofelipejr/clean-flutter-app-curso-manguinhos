import '../../../domain/entities/entities.dart';

abstract class LoadSurveysResult {
  Future<SurveyResultEntity> loadBySurvey({String surveyId});
}
