import 'package:fordev/shared/routes/routes.dart';

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
}
