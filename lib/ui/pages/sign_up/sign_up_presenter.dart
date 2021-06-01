/*
 * ANCHOR - PRESENTER
 * Esse presenter é uma abstração genérica, que se refere as necessidades que oLoginPage possui. 
 * A implementação dela (classe concréta) será algo voltado a alguma biblioteca.
 * Quando mais genérico deixarmos o presenter, mais ele fica reutilizável e o mínimo será necessário 
 * alterá-lo, caso queiramos utilizar o Mobx ou qualquer outra lib que desejarmos.
*/
import '../../../ui/helpers/helpers.dart';

abstract class SignUpPresenter {
  Stream<UiError?> get nameErrorStream;
  Stream<UiError?> get emailErrorStream;
  Stream<UiError?> get passwordErrorStream;
  Stream<UiError?> get passwordConfirmationErrorStream;
  Stream<UiError?> get mainErrorStream;
  Stream<String?> get navigateToStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;

  void validateName(String email);
  void validateEmail(String email);
  void validatePassword(String password);
  void validatePasswordConfirmation(String password);
  Future<void> signUp();
  void dispose();
}
