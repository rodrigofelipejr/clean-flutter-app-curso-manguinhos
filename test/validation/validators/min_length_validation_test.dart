import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fordev/presentation/dependencies/validation.dart';
import 'package:fordev/validation/validators/validators.dart';

main() {
  late MinLengthValidation sut;

  setUp(() {
    sut = MinLengthValidation(field: 'any_field', length: 5);
  });

  test('Should return error if value is empty', () {
    expect(sut.validate({'any_field': ''}), ValidationErro.invalidField);
  });

  test('Should return error if value is null', () {
    expect(sut.validate({'any_field': null}), ValidationErro.invalidField);
  });

  test('Should return error if value is less then min size', () {
    expect(sut.validate({'any_field': faker.randomGenerator.string(4, min: 1)}), ValidationErro.invalidField);
  });

  test('Should return error if value is equal than min size', () {
    expect(sut.validate({'any_field': faker.randomGenerator.string(5, min: 5)}), null);
  });

  test('Should return error if value is bigger than min size', () {
    expect(sut.validate({'any_field': faker.randomGenerator.string(10, min: 6)}), null);
  });
}
