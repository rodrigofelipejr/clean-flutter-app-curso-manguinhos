import 'dart:async';

import '../../ui/helpers/errors/errors.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../dependencies/dependencies.dart';

//NOTE - apenas para fins didáticos
abstract class LoginPresenterStream {
  Stream<UiError?>? get emailErrorStream;
  Stream<UiError?>? get passwordErrorStream;
  Stream<UiError?>? get mainErrorStream;
  Stream<String?>? get navigateToStream;
  Stream<bool>? get isFormValidStream;
  Stream<bool>? get isLoadingStream;

  void validateEmail(String email);
  void validatePassword(String password);
  Future<void> auth();
  void dispose();
}

class LoginState {
  UiError? emailError;
  UiError? passwordError;
  UiError? mainError;
  String? email;
  String? password;
  String? navigateTo;
  bool isLoading = false;

  bool get isFormValid => emailError == null && passwordError == null && email != null && password != null;
}

class StreamLoginPresenter implements LoginPresenterStream {
  final Validation validation;
  final Authentication authentication;
  StreamController<LoginState>? _controller = StreamController<LoginState>.broadcast(); // sync: true

  var _state = LoginState();

  //ANCHOR - O distinct não permite que sejam emitidos valores iguais
  Stream<UiError?>? get emailErrorStream => _controller?.stream.map((state) => state.emailError).distinct();
  Stream<UiError?>? get passwordErrorStream => _controller?.stream.map((state) => state.passwordError).distinct();
  Stream<UiError?>? get mainErrorStream => _controller?.stream.map((state) => state.mainError).distinct();
  Stream<String?>? get navigateToStream => _controller?.stream.map((state) => state.navigateTo).distinct();
  Stream<bool>? get isFormValidStream => _controller?.stream.map((state) => state.isFormValid).distinct();
  Stream<bool>? get isLoadingStream => _controller?.stream.map((state) => state.isLoading).distinct();

  StreamLoginPresenter({required this.validation, required this.authentication});

  void _update() {
    if (_controller != null) {
      if (!_controller!.isClosed == true) {
        _controller?.add(_state);
      }
    }
  }

  void validateEmail(String email) {
    _state.email = email;
    _state.emailError = _validateField(field: 'email', value: email);
    _update();
  }

  void validatePassword(String password) {
    _state.password = password;
    _state.passwordError = _validateField(field: 'password', value: password);
    _update();
  }

  UiError? _validateField({required String field, required String value}) {
    final error = validation.validate(field: field, value: value);

    switch (error) {
      case ValidationErro.invalidField:
        return UiError.invalidField;

      case ValidationErro.requiredField:
        return UiError.requiredField;

      default:
        return null;
    }
  }

  Future<void> auth() async {
    _state.isLoading = true;
    _update();

    try {
      await authentication.auth(params: AuthenticationParams(email: _state.email!, secret: _state.password!));
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          _state.mainError = UiError.invalidCredentials;
          break;
        default:
          _state.mainError = UiError.unexpected;
          break;
      }
    }

    _state.isLoading = false;
    _update();
  }

  void dispose() {
    _controller?.close();
    _controller = null;
  }
}
