import '../../presentation/dependencies/dependencies.dart';

abstract class FieldValidation {
  String get field;
  ValidationErro? validate(Map input);
}
