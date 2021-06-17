import '../../../domain/usecases/usecases.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../data/models/models.dart';
import '../../../data/cache/cache.dart';

class LocalLoadSurveys implements LoadSurveys {
  final CacheStorage cacheStorage;

  LocalLoadSurveys({required this.cacheStorage});

  @override
  Future<List<SurveyEntity>> load() async {
    try {
      final data = await cacheStorage.fetch('surveys');
      if (data?.isEmpty != false) throw Exception();
      return data.map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json).toEntity()).toList();
    } catch (e) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate() async {
    final data = await cacheStorage.fetch('surveys');
    try {
      data.map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json).toEntity()).toList();
    } catch (e) {
      await cacheStorage.delete('surveys');
    }
  }
}
