import '../../../data/usecases/usecases.dart';
import '../../factories/cache/cache.dart';
import '../../../domain/usecases/usecases.dart';

LoadCurrentAccount makeLocalLoadCurrentAccount() {
  return LocalLoadCurrentAccount(fetchSecureCacheStorage: makeLocalStorageSecureAdapter());
}
