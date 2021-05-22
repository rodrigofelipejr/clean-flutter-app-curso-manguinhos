import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';

import '../../ui/pages/pages.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../dependencies/dependencies.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;

  String? _email;
  String? _password;

  var emailError = RxnString();
  var passwordError = RxnString();
  var mainError = RxnString();
  var isFormValid = RxBool(false);
  var isLoading = RxBool(false);

  GetxLoginPresenter({required this.validation, required this.authentication});

  void validateEmail(String email) {
    _email = email;
    emailError.value = validation.validate(field: 'email', value: email);
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    passwordError.value = validation.validate(field: 'password', value: password);
    _validateForm();
  }

  void _validateForm() {
    isFormValid.value = emailError.value == null && passwordError.value == null && _email != null && _password != null;
  }

  Future<void> auth() async {
    isLoading.value = true;

    try {
      await authentication.auth(params: AuthenticationParams(email: _email!, secret: _password!));
    } on DomainError catch (error) {
      mainError.value = error.description;
    }

    isLoading.value = false;
  }
}
