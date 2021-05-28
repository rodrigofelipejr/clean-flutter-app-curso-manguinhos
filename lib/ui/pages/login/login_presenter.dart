/*
 * ANCHOR - PRESENTER
 * Esse presenter é uma abstração genérica, que se refere as necessidades que oLoginPage possui. 
 * A implementação dela (classe concréta) será algo voltado a alguma biblioteca.
 * Quando mais genérico deixarmos o presenter, mais ele fica reutilizável e o mínimo será necessário 
 * alterá-lo, caso queiramos utilizar o Mobx ou qualquer outra lib que desejarmos.
*/
import '../../../ui/helpers/errors/errors.dart';

abstract class LoginPresenter {
  Stream<UiError?> get emailErrorStream;
  Stream<UiError?> get passwordErrorStream;
  Stream<UiError?> get mainErrorStream;
  Stream<String?> get navigateToStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;

  void validateEmail(String email);
  void validatePassword(String password);
  Future<void> auth();
  void dispose();
}
