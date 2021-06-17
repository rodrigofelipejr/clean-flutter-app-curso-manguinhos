import '../../entities/entities.dart';

abstract class LoadSurveys {
  Future<List<SurveyEntity>> load();
  // Future<void> validate();
  // Future<void> save(List<SurveyEntity> list);
}
