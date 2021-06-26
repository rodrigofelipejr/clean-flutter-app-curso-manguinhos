//NOTE - Esse método não sabe se o é seguro ou não, ele apenas salva os dados
import '../../entities/account_entity.dart';

abstract class SaveCurrentAccount {
  Future<void> save(AccountEntity account);
}
