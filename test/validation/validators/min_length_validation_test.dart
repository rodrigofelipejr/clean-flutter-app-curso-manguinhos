import 'package:flutter_test/flutter_test.dart';

import 'package:fordev/presentation/dependencies/validation.dart';
import 'package:fordev/validation/dependencies/dependencies.dart';

class MinLengthValidation implements FieldValidation {
  final String field;
  final int length;

  MinLengthValidation({required this.field, required this.length});

  @override
  ValidationErro? validate(String? value) {
    return ValidationErro.invalidField;
  }
}

main() {
  test('Should return error if value is empty', () {
    final sut = MinLengthValidation(field: 'any_field', length: 5);
    final error = sut.validate('');
    expect(error, ValidationErro.invalidField);
  });

  test('Should return error if value is null', () {
    final sut = MinLengthValidation(field: 'any_field', length: 5);
    final error = sut.validate(null);
    expect(error, ValidationErro.invalidField);
  });
}
