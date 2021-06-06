import 'package:faker/faker.dart';
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
  late MinLengthValidation sut;

  setUp(() {
    sut = MinLengthValidation(field: 'any_field', length: 5);
  });

  test('Should return error if value is empty', () {
    expect(sut.validate(''), ValidationErro.invalidField);
  });

  test('Should return error if value is null', () {
    expect(sut.validate(null), ValidationErro.invalidField);
  });

  test('Should return error if value is less then min size', () {
    expect(sut.validate(faker.randomGenerator.string(4, min: 1)), ValidationErro.invalidField);
  });
}
