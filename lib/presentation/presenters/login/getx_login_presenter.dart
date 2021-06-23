import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';

import '../../../shared/routes/routes.dart';
import '../../../ui/helpers/helpers.dart';
import '../../../ui/pages/pages.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../presentation/dependencies/dependencies.dart';
import '../../../presentation/mixins/mixins.dart';

class GetxLoginPresenter extends GetxController
    with LoadingManager, FormManager, NavigationManager, UIErrorManager
    implements LoginPresenter {
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

  Stream<UiError?> get emailErrorStream => _emailError.stream;
  Stream<UiError?> get passwordErrorStream => _passwordError.stream;

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
    isFormValid = _emailError.value == null && _passwordError.value == null && _email != null && _password != null;
  }

  @override
  Future<void> auth() async {
    try {
      mainError = null;
      isLoading = true;
      final account = await authentication.auth(params: AuthenticationParams(email: _email!, secret: _password!));
      await saveCurrentAccount.save(account);
      /** 
       * NOTE - para que o presentation fique livre de implementação do flutter, a responsabilidade de navegação 
       * não vai ficar aqui dentro, e sim dentro da UI 
       */
      navigateTo = AppRoutes.surveys;
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          mainError = UiError.invalidCredentials;
          break;
        default:
          mainError = UiError.unexpected;
          break;
      }
    } finally {
      isLoading = false;
    }
  }

  @override
  void goToSignUp() {
    navigateTo = AppRoutes.singUp;
  }
}
