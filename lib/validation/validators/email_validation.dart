import 'package:equatable/equatable.dart';
import 'package:fordev/presentation/dependencies/validation.dart';

import '../dependencies/dependencies.dart';

class EmailValidation extends Equatable implements FieldValidation {
  final String field;

  EmailValidation(this.field);

  @override
  ValidationErro? validate(Map input) {
    final regexp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.([a-zA-Z]{2})+");
    final isValid = input[field]?.isNotEmpty != true || regexp.hasMatch(input[field]!);
    return isValid ? null : ValidationErro.invalidField;
  }

  @override
  List<Object?> get props => [field];
}
