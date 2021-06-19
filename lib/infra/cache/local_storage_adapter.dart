import 'package:localstorage/localstorage.dart';

import '../../data/cache/cache.dart';

class LocalStorageAdapter implements CacheStorage {
  final LocalStorage localStorage;

  LocalStorageAdapter({required this.localStorage});

  @override
  Future<void> save({required String key, required dynamic value}) async {
    await localStorage.ready;
    await localStorage.deleteItem(key);
    await localStorage.setItem(key, value);
  }

  @override
  Future<void> delete(String key) async {
    await localStorage.ready;
    await localStorage.deleteItem(key);
  }

  @override
  Future<dynamic> fetch(String key) async {
    await localStorage.ready;
    return await localStorage.getItem(key);
  }
}
