// import 'package:get/get_state_manager/get_state_manager.dart';
// import 'package:get/state_manager.dart';

// import '../../ui/helpers/helpers.dart';
// import '../../ui/pages/pages.dart';

// import '../../domain/helpers/helpers.dart';
// import '../../domain/usecases/usecases.dart';

// import '../dependencies/dependencies.dart';

// class GetxSignUpPresenter extends GetxController implements SignUpPresenter {
//   final Validation validation;

//   GetxSignUpPresenter({
//     required this.validation,
//   });

//   String? _name;
//   String? _email;
//   String? _password;
//   String? _passwordConfirmation;

//   var _emailError = Rxn<UiError>();
//   var _passwordError = Rxn<UiError>();
//   var _mainError = Rxn<UiError>();
//   var _navigateTo = RxnString();
//   var _isFormValid = RxBool(false);
//   var _isLoading = RxBool(false);

//   Stream<UiError?> get emailErrorStream => _emailError.stream;
//   Stream<UiError?> get passwordErrorStream => _passwordError.stream;
//   Stream<UiError?> get mainErrorStream => _mainError.stream;
//   Stream<String?> get navigateToStream => _navigateTo.stream;
//   Stream<bool> get isFormValidStream => _isFormValid.subject.stream;
//   Stream<bool> get isLoadingStream => _isLoading.subject.stream;

//   void validateEmail(String email) {
//     _email = email;
//     _emailError.value = _validateField(field: 'email', value: email);
//     _validateForm();
//   }

//   void validatePassword(String password) {
//     _password = password;
//     _passwordError.value = _validateField(field: 'password', value: password);
//     _validateForm();
//   }

//   UiError? _validateField({required String field, required String value}) {
//     final error = validation.validate(field: field, value: value);

//     switch (error) {
//       case ValidationErro.invalidField:
//         return UiError.invalidField;

//       case ValidationErro.requiredField:
//         return UiError.requiredField;

//       default:
//         return null;
//     }
//   }

//   void _validateForm() {
//     _isFormValid.value =
//         _emailError.value == null && _passwordError.value == null && _email != null && _password != null;
//   }

//   Future<void> auth() async {
//     try {
//       _isLoading.value = true;
//       final account = await authentication.auth(params: AuthenticationParams(email: _email!, secret: _password!));
//       await saveCurrentAccount.save(account);
//       /** 
//        * ANCHOR - para que o presentation fique livre de implementação do flutter, a responsabilidade de navegação 
//        * não vai ficar aqui dentro, e sim dentro da UI 
//        */
//       _navigateTo.value = '/surveys';
//     } on DomainError catch (error) {
//       switch (error) {
//         case DomainError.invalidCredentials:
//           _mainError.value = UiError.invalidCredentials;
//           break;
//         default:
//           _mainError.value = UiError.unexpected;
//           break;
//       }
//       _isLoading.value = false;
//     }
//   }
// }