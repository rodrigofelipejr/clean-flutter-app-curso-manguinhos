import 'package:equatable/equatable.dart';
import 'package:fordev/presentation/dependencies/validation.dart';
import 'package:fordev/validation/dependencies/field_validation.dart';

class CompareFieldsValidation extends Equatable implements FieldValidation {
  final String field;
  final String valueToCompare;

  CompareFieldsValidation({required this.field, required this.valueToCompare});

  @override
  ValidationErro? validate(String? value) {
    return value == valueToCompare ? null : ValidationErro.invalidField;
  }

  @override
  List<Object?> get props => [field, valueToCompare];
}
