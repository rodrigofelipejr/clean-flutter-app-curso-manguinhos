import 'dart:async';

import '../dependencies/dependencies.dart';

class LoginState {
  String? emailError;
  String? passwordError;
  bool get isFormValid => false;
}

class StreamLoginPresenter {
  final Validation validation;
  final _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  // ANCHOR o distinct não permite que sejam emitidos valores iguais
  Stream<String?> get emailErrorStream => _controller.stream.map((state) => state.emailError).distinct();
  Stream<String?> get passwordErrorStream => _controller.stream.map((state) => state.passwordError).distinct();
  Stream<bool> get isFormValidStream => _controller.stream.map((state) => state.isFormValid).distinct();

  StreamLoginPresenter({required this.validation});

  void validateEmail(String email) {
    _state.emailError = validation.validate(field: 'email', value: email);
    _controller.add(_state);
  }

  void validatePassword(String password) {
    validation.validate(field: 'password', value: password);
  }
}
