import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';

import '../../ui/pages/pages.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../dependencies/dependencies.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  GetxLoginPresenter({
    required this.validation,
    required this.authentication,
    required this.saveCurrentAccount,
  });

  String? _email;
  String? _password;

  var _emailError = RxnString();
  var _passwordError = RxnString();
  var _mainError = RxnString();
  var _isFormValid = RxBool(false);
  var _isLoading = RxBool(false);

  Stream<String?> get emailErrorStream => _emailError.stream;
  Stream<String?> get passwordErrorStream => _passwordError.stream;
  Stream<String?> get mainErrorStream => _mainError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.subject.stream;
  Stream<bool> get isLoadingStream => _isLoading.subject.stream;

  void validateEmail(String email) {
    _email = email;
    _emailError.value = validation.validate(field: 'email', value: email);
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = validation.validate(field: 'password', value: password);
    _validateForm();
  }

  void _validateForm() {
    _isFormValid.value =
        _emailError.value == null && _passwordError.value == null && _email != null && _password != null;
  }

  Future<void> auth() async {
    _isLoading.value = true;
    try {
      final account = await authentication.auth(params: AuthenticationParams(email: _email!, secret: _password!));
      await saveCurrentAccount.save(account);
    } on DomainError catch (error) {
      _mainError.value = error.description;
    }
    _isLoading.value = false;
  }
}
