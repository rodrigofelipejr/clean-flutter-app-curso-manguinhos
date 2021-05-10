import '../../entities/entities.dart';

import 'authentication_params.dart';

abstract class Authentication {
  Future<AccountEntity> auth({required AuthenticationParams params});
}
