import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/cache/delete_secure_cache_storage.dart';
import '../../data/cache/cache.dart';

class LocalStorageSecureAdapter implements SaveSecureCacheStorage, FetchSecureCacheStorage, DeleteSecureCacheStorage {
  final FlutterSecureStorage secureStorage;

  LocalStorageSecureAdapter({required this.secureStorage});

  @override
  Future<void> save({required String key, required String value}) async {
    await secureStorage.write(key: key, value: value);
  }

  @override
  Future<String> fetch(String key) async {
    return await secureStorage.read(key: key) ?? '';
  }

  @override
  Future<void> delete(String key) async {
    await secureStorage.delete(key: key);
  }
}
