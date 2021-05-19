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
  test('Should return null if email if empty', () {
    final sut = EmailValidation('any_field');
    final error = sut.validate('');
    expect(error, null);
  });
}
