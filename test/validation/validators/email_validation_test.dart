import 'package:flutter_test/flutter_test.dart';

import 'package:fordev/validation/dependencies/field_validation.dart';

class EmailValidation implements FieldValidation {
  final String field;

  EmailValidation(this.field);

  @override
  String? validate(String? value) {
    return null;
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
    expect(sut.validate('rodrigo@gmail.com'), null);
  });
}
