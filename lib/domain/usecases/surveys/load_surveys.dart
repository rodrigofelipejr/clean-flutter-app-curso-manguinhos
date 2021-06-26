import '../../../domain/entities/entities.dart';

//NOTE - Implementa regra de negócio

abstract class LoadSurveys {
  Future<List<SurveyEntity>> load();
}
