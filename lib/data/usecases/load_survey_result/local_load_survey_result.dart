import '../../../shared/routes/routes.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../data/models/models.dart';
import '../../../data/cache/cache.dart';

class LocalLoadSurveyResult implements LoadSurveyResult {
  final CacheStorage cacheStorage;

  LocalLoadSurveyResult({required this.cacheStorage});

  @override
  Future<SurveyResultEntity> loadBySurvey({String? surveyId}) async {
    try {
      final data = await cacheStorage.fetch('${AppRoutes.surveyResult}/$surveyId');
      if (data?.isEmpty != false) throw Exception();
      return LocalSurveyResultModel.fromJson(data).toEntity();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate(String surveyId) async {
    try {
      final data = await cacheStorage.fetch('${AppRoutes.surveyResult}/$surveyId');
      LocalSurveyResultModel.fromJson(data).toEntity();
    } catch (error) {
      await cacheStorage.delete('${AppRoutes.surveyResult}/$surveyId');
    }
  }

  Future<void> save(SurveyResultEntity surveyResult) async {
    try {
      final json = LocalSurveyResultModel.fromEntity(surveyResult).toJson();
      await cacheStorage.save(key: '${AppRoutes.surveyResult}/${surveyResult.surveysId}', value: json);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
