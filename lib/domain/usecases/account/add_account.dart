import '../../entities/entities.dart';

import 'add_account_params.dart';

abstract class AddAccount {
  Future<AccountEntity> add({required AddAccountParams params});
}
