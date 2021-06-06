import 'package:equatable/equatable.dart';

import '../../validation/dependencies/dependencies.dart';
import '../../presentation/dependencies/dependencies.dart';

class MinLengthValidation extends Equatable implements FieldValidation {
  final String field;
  final int length;

  MinLengthValidation({required this.field, required this.length});

  @override
  ValidationErro? validate(String? value) {
    return value != null && value.length >= length ? null : ValidationErro.invalidField;
  }

  @override
  List<Object?> get props => [field, length];
}
