import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/main/factories/pages/pages.dart';
import 'package:fordev/validation/validators/validators.dart';

main() {
  test('Should return the correct validations', () {
    final validations = makeSignUpValidations();
    expect(validations, [
      RequiredFieldValidation('name'),
      MinLengthValidation(field: 'name', length: 3),
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password'),
      MinLengthValidation(field: 'password', length: 6),
      RequiredFieldValidation('passwordConfirmation'),
      MinLengthValidation(field: 'passwordConfirmation', length: 6),
      CompareFieldsValidation(field: 'passwordConfirmation', fieldToCompare: 'password')
    ]);
  });
}
