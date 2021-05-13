/*
 * ANCHOR  PRESENTER
 * Esse presenter é uma abstração genérica, que se refere as necessidades que oLoginPage possui. 
 * A implementação dela (classe concréta) será algo voltado a alguma biblioteca.
*/
abstract class LoginPresenter {
  void validateEmail(String email);
  void validatePassword(String password);
}
