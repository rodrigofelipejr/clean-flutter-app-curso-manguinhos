import 'package:flutter_test/flutter_test.dart';

import 'package:fordev/presentation/dependencies/dependencies.dart';
import 'package:fordev/validation/validators/validators.dart';

main() {
  late EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any_field');
  });

  test('Should return null on invalid case', () {
    expect(sut.validate({}), null);
  });

  test('Should return null if email if empty', () {
    expect(sut.validate({'any_field': ''}), null);
  });

  test('Should return null if email if null', () {
    expect(sut.validate({'any_field': null}), null);
  });

  test('Should return null if email is valid', () {
    expect(sut.validate({'any_field': 'exemplo@gmail.com'}), null);
  });

  test('Should return error if email is invalid', () {
    expect(sut.validate({'any_field': 'exemplo.email'}), ValidationErro.invalidField);
  });
}
