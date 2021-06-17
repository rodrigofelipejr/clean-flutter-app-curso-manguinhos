import '../../../domain/usecases/usecases.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../data/models/models.dart';
import '../../../data/cache/cache.dart';

class LocalLoadSurveys implements LoadSurveys {
  final CacheStorage cacheStorage;

  LocalLoadSurveys({required this.cacheStorage});

  List<SurveyEntity> _map(List<Map> list) =>
      list.map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json).toEntity()).toList();

  @override
  Future<List<SurveyEntity>> load() async {
    try {
      final data = await cacheStorage.fetch('surveys');
      if (data?.isEmpty != false) throw Exception();
      return _map(data);
    } catch (e) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate() async {
    final data = await cacheStorage.fetch('surveys');
    try {
      _map(data);
    } catch (e) {
      await cacheStorage.delete('surveys');
    }
  }
}
