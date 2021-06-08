import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/shared/routes/routes.dart';
import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/presentation/presenters/presenters.dart';
import 'package:fordev/presentation/dependencies/validation.dart';

import 'getx_login_presenter_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<Validation>(as: #ValidationMock, returnNullOnMissingStub: true),
  MockSpec<Authentication>(as: #AuthenticationMock, returnNullOnMissingStub: true),
  MockSpec<SaveCurrentAccount>(as: #SaveCurrentAccountMock, returnNullOnMissingStub: true),
])
void main() {
  late GetxLoginPresenter sut;
  late ValidationMock validation;
  late AuthenticationMock authentication;
  late SaveCurrentAccount saveCurrentAccount;

  late String email;
  late String password;
  late String token;

  PostExpectation mockValidationCall(String? field) =>
      when(validation.validate(field: field == null ? anyNamed('field') : field, input: anyNamed('input')));

  void mockValidation({String? field, ValidationErro? value}) {
    mockValidationCall(field).thenReturn(value);
  }

  PostExpectation mockAuthenticationCall() => when(authentication.auth(params: anyNamed('params')));

  void mockAuthentication() {
    mockAuthenticationCall().thenAnswer((_) async => AccountEntity(token));
  }

  void mockAuthenticationError(DomainError error) {
    mockAuthenticationCall().thenThrow(error);
  }

  PostExpectation mockSaveCurrentAccountCall() => when(authentication.auth(params: anyNamed('params')));

  void mockSaveCurrentAccountError() {
    mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);
  }

  setUp(() {
    validation = ValidationMock();
    authentication = AuthenticationMock();
    saveCurrentAccount = SaveCurrentAccountMock();
    sut = GetxLoginPresenter(
      validation: validation,
      authentication: authentication,
      saveCurrentAccount: saveCurrentAccount,
    );

    email = faker.internet.email();
    password = faker.internet.password();
    token = faker.guid.guid();

    mockValidation(); // SUCCESS
    mockAuthentication(); // SUCCESS
  });

  test('Should call Validation with correct e-mail', () {
    final formData = {'email': email, 'password': null};
    sut.validateEmail(email);
    verify(validation.validate(field: 'email', input: formData)).called(1);
  });

  test('Should emit invalidFieldError if email is invalid', () {
    mockValidation(value: ValidationErro.invalidField);
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UiError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit requiredFieldError if email is empty', () {
    mockValidation(field: 'email', value: ValidationErro.requiredField);
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UiError.requiredField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null if email validation succeeds', () {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call Validation with correct password', () {
    final formData = {'email': null, 'password': password};
    sut.validatePassword(password);
    verify(validation.validate(field: 'password', input: formData)).called(1);
  });

  test('Should emit password error if validation fails', () {
    mockValidation(value: ValidationErro.requiredField);
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, UiError.requiredField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit null if password validation succeeds', () {
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should disable form button if any field is invalid', () {
    mockValidation(field: 'email', value: ValidationErro.invalidField);
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('Should enable form button if any field is invalid', () async {
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));
    sut.validateEmail(email);
    await Future.delayed(Duration.zero); //ANCHOR - Hack for stream
    sut.validatePassword(password);
  });

  test('Should call Authentication with correct values', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);
    await sut.auth();
    verify(authentication.auth(params: AuthenticationParams(email: email, secret: password))).called(1);
  });

  test('Should call SaveCurrentAccount with correct value', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);
    await sut.auth();
    verify(saveCurrentAccount.save(AccountEntity(token))).called(1);
  });

  test('Should emit UnexpectedErro if SaveCurrentAccount fails', () async {
    mockSaveCurrentAccountError();
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UiError.unexpected]));

    await sut.auth();
  });

  test('Should emit correct event on Authentication success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.mainErrorStream, emits(null));
    expectLater(sut.isLoadingStream, emits(true));

    await sut.auth();
    verify(authentication.auth(params: AuthenticationParams(email: email, secret: password))).called(1);
  });

  test('Should emit correct event on InvalidCredentialError', () async {
    mockAuthenticationError(DomainError.invalidCredentials);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UiError.invalidCredentials]));

    await sut.auth();
    verify(authentication.auth(params: AuthenticationParams(email: email, secret: password))).called(1);
  });

  test('Should emit correct event on UnexpectedError', () async {
    mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UiError.unexpected]));

    await sut.auth();
    verify(authentication.auth(params: AuthenticationParams(email: email, secret: password))).called(1);
  });

  test('Should change page on success ', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    sut.navigateToStream.listen(expectAsync1((page) => AppRoutes.surveys));

    await sut.auth();
  });

  test('Should go to SignUpPage on link click', () async {
    //NOTE - Como estamos testando streams o o teste deve ficar antes da chamada
    sut.navigateToStream.listen(expectAsync1((page) => AppRoutes.singUp));
    sut.goToSignUp();
  });
}
