//NOTE - Esse método não sabe se o é seguro ou não, ele apenas carrega os dados
import '../../entities/account_entity.dart';

abstract class LoadCurrentAccount {
  Future<AccountEntity> load();
}
