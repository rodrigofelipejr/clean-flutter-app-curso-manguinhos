import 'package:flutter_test/flutter_test.dart';

import 'package:fordev/validation/dependencies/field_validation.dart';

class EmailValidation implements FieldValidation {
  final String field;

  EmailValidation(this.field);

  @override
  String? validate(String? value) {
    final regexp = RegExp(
        "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$");
    final isValid = value?.isNotEmpty != true || regexp.hasMatch(value!);
    return isValid ? null : 'Campo inválido';
  }
}

main() {
  late EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any_field');
  });

  test('Should return null if email if empty', () {
    expect(sut.validate(''), null);
  });

  test('Should return null if email if null', () {
    expect(sut.validate(null), null);
  });

  test('Should return null if email is valid', () {
    expect(sut.validate('exemplo@gmail.com'), null);
  });

  test('Should return error if email is invalid', () {
    expect(sut.validate('exemplo.email'), 'Campo inválido');
  });
}
