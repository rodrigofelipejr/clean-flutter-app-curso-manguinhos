import 'package:equatable/equatable.dart';
import 'package:fordev/presentation/dependencies/validation.dart';

import '../dependencies/dependencies.dart';

class EmailValidation extends Equatable implements FieldValidation {
  final String field;

  EmailValidation(this.field);

  @override
  ValidationErro? validate(String? value) {
    final regexp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.([a-zA-Z]{2})+");
    final isValid = value?.isNotEmpty != true || regexp.hasMatch(value!);
    return isValid ? null : ValidationErro.invalidField;
  }

  @override
  List<Object?> get props => [field];
}
