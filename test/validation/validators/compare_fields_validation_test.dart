import 'package:flutter_test/flutter_test.dart';

import 'package:fordev/presentation/dependencies/validation.dart';
import 'package:fordev/validation/validators/validators.dart';

main() {
  late CompareFieldsValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(field: 'any_field', valueToCompare: 'any_value');
  });

  test('Should return error if values are not equal', () {
    expect(sut.validate('wrong_value'), ValidationErro.invalidField);
  });

  test('Should return null if value are equal', () {
    expect(sut.validate('any_value'), null);
  });
}
