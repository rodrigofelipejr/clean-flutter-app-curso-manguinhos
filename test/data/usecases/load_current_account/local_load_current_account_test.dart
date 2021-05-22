import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'local_load_current_account_test.mocks.dart';

abstract class FetchSecureCacheStorage {
  Future<void> fetchSecure(String key);
}

class LocalLoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({required this.fetchSecureCacheStorage});

  Future<void> load(String key) async {
    await fetchSecureCacheStorage.fetchSecure(key);
  }
}

@GenerateMocks([], customMocks: [
  MockSpec<FetchSecureCacheStorage>(as: #FetchSecureCacheStorageMock, returnNullOnMissingStub: true),
])
main() {
  late FetchSecureCacheStorageMock fetchSecureCacheStorage;
  late LocalLoadCurrentAccount sut;
  late String key;

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageMock();
    sut = LocalLoadCurrentAccount(fetchSecureCacheStorage: fetchSecureCacheStorage);
    key = 'token';
  });

  test('Should call FetchSecureCacheStorage with correct value', () async {
    await sut.load(key);
    verify(fetchSecureCacheStorage.fetchSecure(key)).called(1);
  });
}
