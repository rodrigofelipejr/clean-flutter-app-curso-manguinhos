import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';

import '../../ui/helpers/helpers.dart';

import '../dependencies/dependencies.dart';

class GetxSignUpPresenter extends GetxController {
  final Validation validation;

  GetxSignUpPresenter({
    required this.validation,
  });

  var _emailError = Rxn<UiError>();
  var _isFormValid = RxBool(false);

  Stream<UiError?> get emailErrorStream => _emailError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.subject.stream;

  void validateEmail(String email) {
    _emailError.value = _validateField(field: 'email', value: email);
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
    _isFormValid.value = _emailError.value == false;
  }
}
