import 'package:equatable/equatable.dart';

import '../../presentation/dependencies/validation.dart';
import '../../validation/dependencies/field_validation.dart';

class CompareFieldsValidation extends Equatable implements FieldValidation {
  final String field;
  final String fieldToCompare;

  CompareFieldsValidation({required this.field, required this.fieldToCompare});

  @override
  ValidationErro? validate(Map input) {
    return input[field] != null && input[fieldToCompare] != null && input[field] != input[fieldToCompare]
        ? ValidationErro.invalidField
        : null;
  }

  @override
  List<Object?> get props => [field, fieldToCompare];
}
