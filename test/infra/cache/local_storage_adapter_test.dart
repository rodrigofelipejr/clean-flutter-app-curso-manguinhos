import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fordev/data/cache/cache.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'local_storage_adapter_test.mocks.dart';

class LocalStorageAdapter implements SaveSecureCacheStorage {
  final FlutterSecureStorage secureStorage;

  LocalStorageAdapter({required this.secureStorage});

  Future<void> saveSecure({required String key, required String value}) async {
    await secureStorage.write(key: key, value: value);
  }
}

@GenerateMocks([], customMocks: [MockSpec<FlutterSecureStorage>(as: #FlutterSecureStorageMock)])
main() {
  test('Should call save secure correct values', () async {
    final secureStorage = FlutterSecureStorageMock();
    final key = faker.lorem.word();
    final value = faker.guid.guid();
    final sut = LocalStorageAdapter(secureStorage: secureStorage);

    await sut.saveSecure(key: key, value: value);
    verify(secureStorage.write(key: key, value: value));
  });
}
