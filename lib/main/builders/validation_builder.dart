import '../../validation/dependencies/dependencies.dart';
import '../../validation/validators/validators.dart';

//NOTE - Designer partner builder

class ValidationBuilder {
  static late ValidationBuilder _instance;
  late String fieldName;

  List<FieldValidation> validations = [];

  ValidationBuilder._(); //NOTE - Construtor privado

  static ValidationBuilder field(String fieldName) {
    _instance = ValidationBuilder._();
    _instance.fieldName = fieldName;
    return _instance;
  }

  ValidationBuilder required() {
    validations.add(RequiredFieldValidation(fieldName));
    return this;
  }

  ValidationBuilder email() {
    validations.add(EmailValidation(fieldName));
    return this;
  }

  ValidationBuilder min(int length) {
    validations.add(MinLengthValidation(field: fieldName, length: length));
    return this;
  }

  ValidationBuilder sameAs(String fieldToCompare) {
    validations.add(CompareFieldsValidation(field: fieldName, fieldToCompare: fieldToCompare));
    return this;
  }

  List<FieldValidation> build() => validations;
}
