import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import 'package:fordev/presentation/presenters/presenters.dart';
import 'package:fordev/presentation/dependencies/validation.dart';

import 'stream_login_presenter_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<Validation>(as: #ValidationMock, returnNullOnMissingStub: true),
  MockSpec<Authentication>(as: #AuthenticationMock, returnNullOnMissingStub: true),
])
void main() {
  late StreamLoginPresenter sut;
  late ValidationMock validation;
  late AuthenticationMock authentication;
  late String email;
  late String password;

  PostExpectation mockValidationCall(String? field) =>
      when(validation.validate(field: field == null ? anyNamed('field') : field, value: anyNamed('value')));

  void mockValidation({String? field, String? value}) {
    mockValidationCall(field).thenReturn(value);
  }

  PostExpectation mockAuthenticationCall() => when(authentication.auth(params: anyNamed('params')));

  void mockAuthentication() {
    mockAuthenticationCall().thenAnswer((_) async => AccountEntity(faker.guid.guid()));
  }

  void mockAuthenticationError(DomainError error) {
    mockAuthenticationCall().thenThrow(error);
  }

  setUp(() {
    validation = ValidationMock();
    authentication = AuthenticationMock();
    sut = StreamLoginPresenter(validation: validation, authentication: authentication);

    email = faker.internet.email();
    password = faker.internet.password();

    mockValidation(); // SUCCESS
    mockAuthentication(); // SUCCESS
  });

  test('Should call Validation with correct e-mail', () {
    sut.validateEmail(email);
    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () {
    mockValidation(value: 'error');
    sut.emailErrorStream!.listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream!.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null if validation succeeds', () {
    sut.emailErrorStream!.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream!.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call Validation with correct password', () {
    sut.validatePassword(password);
    verify(validation.validate(field: 'password', value: password)).called(1);
  });

  test('Should emit password error if validation fails', () {
    mockValidation(value: 'error');
    sut.passwordErrorStream!.listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream!.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit password error if validation fails', () {
    sut.passwordErrorStream!.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream!.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit an invalid form error if any fields are invalid', () {
    mockValidation(field: 'email', value: 'error');
    sut.emailErrorStream!.listen(expectAsync1((error) => expect(error, 'error')));
    sut.passwordErrorStream!.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream!.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('Should emit an invalid form error if any fields are invalid', () async {
    sut.emailErrorStream!.listen(expectAsync1((error) => expect(error, null)));
    sut.passwordErrorStream!.listen(expectAsync1((error) => expect(error, null)));
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

  test('Should emit correct event on Authentication success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.auth();
    verify(authentication.auth(params: AuthenticationParams(email: email, secret: password))).called(1);
  });

  test('Should emit correct event on InvalidCredentialError', () async {
    mockAuthenticationError(DomainError.invalidCredentials);
    sut.validateEmail(email);
    sut.validatePassword(password);

    // expectLater(sut.isLoadingStream, emitsInOrder([true, false])); //ANCHOR - Por conta do try catch da erro?
    expectLater(sut.isLoadingStream, emits(false));
    sut.mainErrorStream!.listen(expectAsync1((error) => expect(error, 'Credenciais inválidas.')));

    await sut.auth();
    verify(authentication.auth(params: AuthenticationParams(email: email, secret: password))).called(1);
  });

  test('Should emit correct event on UnexpectedError', () async {
    mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(false));
    sut.mainErrorStream!
        .listen(expectAsync1((error) => expect(error, 'Algo errado aconteceu. Tente novamente em breve.')));

    await sut.auth();
    verify(authentication.auth(params: AuthenticationParams(email: email, secret: password))).called(1);
  });

  test('Should not emit after dispose', () async {
    expectLater(sut.emailErrorStream, neverEmits(null));
    sut.dispose();
    sut.validateEmail(email);
  });
}
