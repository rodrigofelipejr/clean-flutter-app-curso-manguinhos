/*
 * ANCHOR - PRESENTER
 * Esse presenter é uma abstração genérica, que se refere as necessidades que oLoginPage possui. 
 * A implementação dela (classe concréta) será algo voltado a alguma biblioteca.
 * Quando mais genérico deixarmos o presenter, mais ele fica reutilizável e o mínimo será necessário 
 * alterá-lo, caso queiramos utilizar o Mobx ou qualquer outra lib que desejarmos.
*/
import 'package:get/state_manager.dart';

abstract class LoginPresenter {
  RxnString get emailError;
  RxnString get passwordError;
  RxnString get mainError;
  RxBool get isFormValid;
  RxBool get isLoading;

  void validateEmail(String email);
  void validatePassword(String password);
  Future<void> auth();
}

/**
 * ANCHOR - o GetX vei parar aqui dentro, dessa forma estamos acoplando o package a nossa 
 * interface que deveria ser o mais genérica possível
 */