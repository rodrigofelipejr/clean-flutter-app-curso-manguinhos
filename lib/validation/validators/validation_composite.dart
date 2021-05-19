// ANCHOR Vai ser genérico, reaproveitável para qualquer tipo de validação de formulário

import '../../validation/dependencies/dependencies.dart';
import '../../presentation/dependencies/dependencies.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  String? validate({required String field, required String value}) {
    String? error;

    for (final validation in validations.where((v) => v.field == field)) {
      final error = validation.validate(value);
      if (error?.isNotEmpty == true) return error;
    }

    return error;
  }
}
