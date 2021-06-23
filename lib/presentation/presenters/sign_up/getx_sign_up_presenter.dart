import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../ui/pages/pages.dart';
import '../../../ui/helpers/helpers.dart';
import '../../../shared/routes/routes.dart';
import '../../../presentation/mixins/mixins.dart';

import '../../dependencies/dependencies.dart';

class GetxSignUpPresenter extends GetxController
    with LoadingManager, FormManager, NavigationManager, UIErrorManager
    implements SignUpPresenter {
  final Validation validation;
  final AddAccount addAccount;
  final SaveCurrentAccount saveCurrentAccount;

  GetxSignUpPresenter({
    required this.validation,
    required this.addAccount,
    required this.saveCurrentAccount,
  });

  var _nameError = Rxn<UiError>();
  var _emailError = Rxn<UiError>();
  var _passwordError = Rxn<UiError>();
  var _passwordConfirmationError = Rxn<UiError>();

  String? _name;
  String? _email;
  String? _password;
  String? _passwordConfirmation;

  Stream<UiError?> get nameErrorStream => _nameError.stream;
  Stream<UiError?> get emailErrorStream => _emailError.stream;
  Stream<UiError?> get passwordErrorStream => _passwordError.stream;
  Stream<UiError?> get passwordConfirmationErrorStream => _passwordConfirmationError.stream;

  @override
  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField('name');
    _validateForm();
  }

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

  @override
  void validatePasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    _passwordConfirmationError.value = _validateField('passwordConfirmation');
    _validateForm();
  }

  UiError? _validateField(String field) {
    final formData = {
      'name': _name,
      'email': _email,
      'password': _password,
      'passwordConfirmation': _passwordConfirmation,
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
    isFormValid = _name != null &&
        _nameError.value == null &&
        _email != null &&
        _emailError.value == null &&
        _password != null &&
        _passwordError.value == null &&
        _passwordConfirmation != null &&
        _passwordConfirmationError.value == null;
  }

  @override
  Future<void> signUp() async {
    try {
      isLoading = true;
      mainError = null;
      final account = await addAccount.add(
        params: AddAccountParams(
          name: _name!,
          email: _email!,
          password: _password!,
          passwordConfirmation: _passwordConfirmation!,
        ),
      );

      await saveCurrentAccount.save(account);
      navigateTo = AppRoutes.surveys;
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.emailInUse:
          mainError = UiError.emailInUse;
          break;
        default:
          mainError = UiError.unexpected;
      }
      isLoading = false;
    }
  }

  @override
  void goToLogin() {
    navigateTo = AppRoutes.login;
  }
}
