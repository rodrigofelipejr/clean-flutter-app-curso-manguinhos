import 'package:localstorage/localstorage.dart';

class LocalStorageAdapter {
  final LocalStorage localStorage;

  LocalStorageAdapter(this.localStorage);

  Future<void> save({required String key, required dynamic value}) async {
    await localStorage.setItem(key, value);
  }
}
