import 'package:equatable/equatable.dart';
import 'package:fordev/presentation/dependencies/dependencies.dart';

import '../dependencies/dependencies.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  final String field;

  RequiredFieldValidation(this.field);

  @override
  ValidationErro? validate(Map input) {
    return input[field]?.isNotEmpty == true ? null : ValidationErro.requiredField;
  }

  @override
  List<Object?> get props => [field];
}
