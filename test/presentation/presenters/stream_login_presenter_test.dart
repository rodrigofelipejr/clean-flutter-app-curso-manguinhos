import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'stream_login_presenter_test.mocks.dart';

abstract class Validation {
  String? validate({required String field, required String value});
}

class LoginState {
  String? emailError;
}

class StreamLoginPresenter {
  final Validation validation;
  final _controller = StreamController<LoginState>.broadcast();
  var _state = LoginState();

  Stream<String?> get emailErrorStream => _controller.stream.map((state) => state.emailError);
  StreamLoginPresenter({required this.validation});

  void validateEmail(String email) {
    _state.emailError = validation.validate(field: 'email', value: email);
    _controller.add(_state);
  }
}

@GenerateMocks([], customMocks: [MockSpec<Validation>(as: #ValidationMock, returnNullOnMissingStub: true)])
void main() {
  late StreamLoginPresenter sut;
  late ValidationMock validation;
  late String email;

  setUp(() {
    validation = ValidationMock();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
  });

  test('Should call Validation with correct e-mail', () {
    sut.validateEmail(email);
    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () {
    when(validation.validate(field: anyNamed('field'), value: anyNamed('value'))).thenReturn('error');
    expectLater(sut.emailErrorStream, emits('error'));
    sut.validateEmail(email);
  });
}
