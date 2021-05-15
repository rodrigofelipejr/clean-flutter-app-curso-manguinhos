import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/presentation/presenters/presenters.dart';
import 'package:fordev/presentation/dependencies/validation.dart';

import 'stream_login_presenter_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<Validation>(as: #ValidationMock, returnNullOnMissingStub: true)])
void main() {
  late StreamLoginPresenter sut;
  late ValidationMock validation;
  late String email;

  PostExpectation mockValidationCall(String? field) =>
      when(validation.validate(field: field == null ? anyNamed('field') : field, value: anyNamed('value')));

  void mockValidation({String? field, String? value}) {
    mockValidationCall(field).thenReturn(value);
  }

  setUp(() {
    validation = ValidationMock();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
    mockValidation(); // SUCCESS
  });

  test('Should call Validation with correct e-mail', () {
    sut.validateEmail(email);
    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () {
    mockValidation(value: 'error');
    expectLater(sut.emailErrorStream, emits('error'));
    sut.validateEmail(email);
  });
}
