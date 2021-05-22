import 'package:fordev/data/usecases/save_current_account/save_current_account.dart';

import '../../factories/cache/cache.dart';
import '../../../domain/usecases/usecases.dart';

SaveCurrentAccount makeSaveCurrentAccount() {
  return LocalSaveCurrentAccount(saveSecureCacheStorage: makeLocalStorageAdapter());
}
