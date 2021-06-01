import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';

import '../../ui/helpers/helpers.dart';

import '../dependencies/dependencies.dart';

class GetxSignUpPresenter extends GetxController {
  final Validation validation;

  GetxSignUpPresenter({
    required this.validation,
  });

  var _nameError = Rxn<UiError>();
  var _emailError = Rxn<UiError>();
  var _passwordError = Rxn<UiError>();
  var _passwordConfirmationError = Rxn<UiError>();
  var _isFormValid = RxBool(false);

  String? _name;
  String? _email;
  String? _password;
  String? _passwordConfirmation;

  Stream<UiError?> get nameErrorStream => _nameError.stream;
  Stream<UiError?> get emailErrorStream => _emailError.stream;
  Stream<UiError?> get passwordErrorStream => _passwordError.stream;
  Stream<UiError?> get passwordConfirmationErrorStream => _passwordConfirmationError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.subject.stream;

  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField(field: 'name', value: name);
    _validateForm();
  }

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField(field: 'email', value: email);
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField(field: 'password', value: password);
    _validateForm();
  }

  void validatePasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    _passwordConfirmationError.value = _validateField(field: 'passwordConfirmation', value: passwordConfirmation);
    _validateForm();
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

  void _validateForm() {
    _isFormValid.value = _name != null &&
        _nameError.value == null &&
        _email != null &&
        _emailError.value == null &&
        _password != null &&
        _passwordError.value == null &&
        _passwordConfirmation != null &&
        _passwordConfirmationError.value == null;
  }
}
