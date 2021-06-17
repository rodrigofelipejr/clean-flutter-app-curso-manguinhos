import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';

import '../../shared/routes/routes.dart';
import '../../ui/helpers/helpers.dart';
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

  var _emailError = Rxn<UiError>();
  var _passwordError = Rxn<UiError>();
  var _mainError = Rxn<UiError>();
  var _navigateTo = RxnString();
  var _isFormValid = RxBool(false);
  var _isLoading = RxBool(false);

  Stream<UiError?> get emailErrorStream => _emailError.stream;
  Stream<UiError?> get passwordErrorStream => _passwordError.stream;
  Stream<UiError?> get mainErrorStream => _mainError.stream;
  Stream<String?> get navigateToStream => _navigateTo.stream;
  Stream<bool> get isFormValidStream => _isFormValid.subject.stream;
  Stream<bool> get isLoadingStream => _isLoading.subject.stream;

  @override
  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField('email');
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField('password');
    _validateForm();
  }

  UiError? _validateField(String field) {
    final formData = {
      'email': _email,
      'password': _password,
    };
    final error = validation.validate(field: field, input: formData);

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
    _isFormValid.value =
        _emailError.value == null && _passwordError.value == null && _email != null && _password != null;
  }

  @override
  Future<void> auth() async {
    try {
      _mainError.value = null;
      _isLoading.value = true;
      final account = await authentication.auth(params: AuthenticationParams(email: _email!, secret: _password!));
      await saveCurrentAccount.save(account);
      /** 
       * ANCHOR - para que o presentation fique livre de implementação do flutter, a responsabilidade de navegação 
       * não vai ficar aqui dentro, e sim dentro da UI 
       */
      _navigateTo.value = AppRoutes.surveys;
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          _mainError.value = UiError.invalidCredentials;
          break;
        default:
          _mainError.value = UiError.unexpected;
          break;
      }
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void goToSignUp() {
    _navigateTo.value = AppRoutes.singUp;
  }
}
