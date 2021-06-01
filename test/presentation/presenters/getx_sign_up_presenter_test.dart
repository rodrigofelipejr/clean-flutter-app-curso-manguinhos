import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/ui/helpers/helpers.dart';

import 'package:fordev/presentation/presenters/presenters.dart';
import 'package:fordev/presentation/dependencies/validation.dart';

import 'getx_sign_up_presenter_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<Validation>(as: #ValidationMock, returnNullOnMissingStub: true),
])
void main() {
  late GetxSignUpPresenter sut;
  late ValidationMock validation;
  late String email;

  PostExpectation mockValidationCall(String? field) =>
      when(validation.validate(field: field == null ? anyNamed('field') : field, value: anyNamed('value')));

  void mockValidation({String? field, ValidationErro? value}) {
    mockValidationCall(field).thenReturn(value);
  }

  setUp(() {
    validation = ValidationMock();
    sut = GetxSignUpPresenter(validation: validation);

    email = faker.internet.email();

    mockValidation(); // SUCCESS
  });

  test('Should call Validation with correct e-mail', () {
    sut.validateEmail(email);
    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit invalid field error if email is invalid', () {
    mockValidation(value: ValidationErro.invalidField);
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UiError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit requiredFieldError if email is empty', () {
    mockValidation(value: ValidationErro.requiredField);
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UiError.requiredField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null if validation succeeds', () {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validateEmail(email);
    sut.validateEmail(email);
  });
}
