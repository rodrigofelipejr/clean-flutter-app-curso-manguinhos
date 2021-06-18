import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../infra/cache/local_storage_secure_adapter.dart';

LocalStorageSecureAdapter makeLocalStorageSecureAdapter() {
  final secureStorage = FlutterSecureStorage();
  return LocalStorageSecureAdapter(secureStorage: secureStorage);
}
