import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'stream_login_presenter_test.mocks.dart';

abstract class Validation {
  String? validate({required String field, required String value});
}

class StreamLoginPresenter {
  final Validation validation;
  StreamLoginPresenter({required this.validation});

  void validateEmail(String email) {
    validation.validate(field: 'email', value: email);
  }
}

@GenerateMocks([], customMocks: [MockSpec<Validation>(as: #ValidationMock, returnNullOnMissingStub: true)])
void main() {
  test('Should call Validation with correct e-mail', () {
    final validation = ValidationMock();
    final sut = StreamLoginPresenter(validation: validation);
    final email = faker.internet.email();

    sut.validateEmail(email);
    verify(validation.validate(field: 'email', value: email)).called(1);
  });
}
