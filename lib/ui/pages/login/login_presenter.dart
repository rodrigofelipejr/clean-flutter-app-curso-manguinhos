/*
 * ANCHOR  PRESENTER
 * Esse presenter é uma abstração genérica, que se refere as necessidades que oLoginPage possui. 
 * A implementação dela (classe concréta) será algo voltado a alguma biblioteca.
 * Quando mais genérico deixarmos o presenter, mais ele fica reutilizável e o mínimo será necessário 
 * alterá-lo, caso queiramos utilizar o Mobx ou qualquer outra lib que desejarmos.
*/
abstract class LoginPresenter {
  Stream<String?> get emailErrorStream;
  Stream<String?> get passwordErrorStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;
  Stream<String?> get mainErrorStream;

  void validateEmail(String email);
  void validatePassword(String password);
  void auth();
}
