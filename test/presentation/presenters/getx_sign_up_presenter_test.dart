import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/presentation/presenters/presenters.dart';
import 'package:fordev/presentation/dependencies/validation.dart';

import 'getx_sign_up_presenter_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<Validation>(as: #ValidationMock, returnNullOnMissingStub: true),
  MockSpec<AddAccount>(as: #AddAccountMock, returnNullOnMissingStub: true),
  MockSpec<SaveCurrentAccount>(as: #SaveCurrentAccountMock, returnNullOnMissingStub: true),
])
void main() {
  late GetxSignUpPresenter sut;
  late ValidationMock validation;
  late AddAccountMock addAccount;
  late SaveCurrentAccount saveCurrentAccount;

  late String name;
  late String email;
  late String password;
  late String passwordConfirmation;
  late String token;

  PostExpectation mockValidationCall(String? field) =>
      when(validation.validate(field: field == null ? anyNamed('field') : field, input: anyNamed('input')));

  void mockValidation({String? field, ValidationErro? value}) {
    mockValidationCall(field).thenReturn(value);
  }

  PostExpectation mockSaveCurrentAccountCall() => when(saveCurrentAccount.save(AccountEntity(token)));

  void mockSaveCurrentAccountError() {
    mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);
  }

  PostExpectation mockAddAccountCall() => when(addAccount.add(params: anyNamed('params')));

  void mockAddAccount() {
    mockAddAccountCall().thenAnswer((_) async => AccountEntity(token));
  }

  void mockAddAccountError(DomainError error) {
    mockAddAccountCall().thenThrow(error);
  }

  setUp(() {
    validation = ValidationMock();
    addAccount = AddAccountMock();
    saveCurrentAccount = SaveCurrentAccountMock();

    sut = GetxSignUpPresenter(
      validation: validation,
      addAccount: addAccount,
      saveCurrentAccount: saveCurrentAccount,
    );

    name = faker.person.name();
    email = faker.internet.email();
    password = faker.internet.password();
    passwordConfirmation = faker.internet.password();
    token = faker.guid.guid();

    mockValidation(); // SUCCESS
    mockAddAccount();
  });

  test('Should call Validation with correct name', () {
    final formData = {'name': name, 'email': null, 'password': null, 'passwordConfirmation': null};
    sut.validateName(name);
    verify(validation.validate(field: 'name', input: formData)).called(1);
  });

  test('Should emit invalid field error if name is invalid', () {
    mockValidation(value: ValidationErro.invalidField);
    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, UiError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit requiredFieldError if name is empty', () {
    mockValidation(value: ValidationErro.requiredField);
    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, UiError.requiredField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit null if validation succeeds', () {
    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should call Validation with correct e-mail', () {
    final formData = {'name': null, 'email': email, 'password': null, 'passwordConfirmation': null};
    sut.validateEmail(email);
    verify(validation.validate(field: 'email', input: formData)).called(1);
  });

  test('Should emit invalid field error if e-mail is invalid', () {
    mockValidation(value: ValidationErro.invalidField);
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UiError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit requiredFieldError if e-mail is empty', () {
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

  test('Should call Validation with correct password', () {
    final formData = {'name': null, 'email': null, 'password': password, 'passwordConfirmation': null};
    sut.validatePassword(password);
    verify(validation.validate(field: 'password', input: formData)).called(1);
  });

  test('Should emit invalid field error if password is invalid', () {
    mockValidation(value: ValidationErro.invalidField);
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, UiError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit requiredFieldError if password is empty', () {
    mockValidation(value: ValidationErro.requiredField);
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, UiError.requiredField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit null if validation succeeds', () {
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should call Validation with correct passwordConfirmation', () {
    final formData = {'name': null, 'email': null, 'password': null, 'passwordConfirmation': passwordConfirmation};
    sut.validatePasswordConfirmation(passwordConfirmation);
    verify(validation.validate(field: 'passwordConfirmation', input: formData)).called(1);
  });

  test('Should emit invalid field error if passwordConfirmation is invalid', () {
    mockValidation(value: ValidationErro.invalidField);
    sut.passwordConfirmationErrorStream.listen(expectAsync1((error) => expect(error, UiError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('Should emit requiredFieldError if passwordConfirmation is empty', () {
    mockValidation(value: ValidationErro.requiredField);
    sut.passwordConfirmationErrorStream.listen(expectAsync1((error) => expect(error, UiError.requiredField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('Should emit null if validation succeeds', () {
    sut.passwordConfirmationErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('Should enable form button if any field is invalid', () async {
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateName(name);
    await Future.delayed(Duration.zero); //ANCHOR - Hack for stream

    sut.validateEmail(email);
    await Future.delayed(Duration.zero); //ANCHOR - Hack for stream

    sut.validatePassword(password);
    await Future.delayed(Duration.zero); //ANCHOR - Hack for stream

    sut.validatePasswordConfirmation(passwordConfirmation);
    await Future.delayed(Duration.zero); //ANCHOR - Hack for stream
  });

  test('Should call AddAccount with correct values', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    await sut.signUp();

    verify(addAccount.add(
        params: AddAccountParams(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    ))).called(1);
  });

  test('Should call SaveCurrentAccount with correct value', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    await sut.signUp();
    verify(saveCurrentAccount.save(AccountEntity(token))).called(1);
  });

  test('Should emit UnexpectedErro if SaveCurrentAccount fails', () async {
    mockSaveCurrentAccountError();
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(expectAsync1((error) => expect(error, UiError.unexpected)));

    await sut.signUp();
  });

  test('Should emit correct events on AddAccount success', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.isLoadingStream, emits(true));

    await sut.signUp();
  });

  test('Should emit correct event on EmailInUseError', () async {
    mockAddAccountError(DomainError.emailInUse);

    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(expectAsync1((error) => expect(error, UiError.emailInUse)));

    await sut.signUp();
  });

  test('Should emit correct event on UnexpectedError', () async {
    mockAddAccountError(DomainError.unexpected);

    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(expectAsync1((error) => expect(error, UiError.unexpected)));

    await sut.signUp();
  });

  test('Should change page on success ', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    sut.navigateToStream.listen(expectAsync1((page) => '/surveys'));

    await sut.signUp();
  });

  test('Should go to LoginPage on link click', () async {
    sut.navigateToStream.listen(expectAsync1((page) => '/login'));
    sut.goToLogin();
  });
}
