import 'package:flutter_test/flutter_test.dart';

import 'package:fordev/presentation/dependencies/dependencies.dart';
import 'package:fordev/validation/validators/validators.dart';

main() {
  late RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any_field');
  });
  test('Should return null if value is not empty', () {
    expect(sut.validate('any_value'), null);
  });

  test('Should return error if value is empty', () {
    expect(sut.validate(''), ValidationErro.requiredField);
  });

  test('Should return error if value is null', () {
    expect(sut.validate(null), ValidationErro.requiredField);
  });
}
