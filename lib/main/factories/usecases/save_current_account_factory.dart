import 'package:fordev/data/usecases/usecases.dart';

import '../../factories/cache/cache.dart';
import '../../../domain/usecases/usecases.dart';

SaveCurrentAccount makeSaveCurrentAccount() {
  return LocalSaveCurrentAccount(saveSecureCacheStorage: makeLocalStorageAdapter());
}
