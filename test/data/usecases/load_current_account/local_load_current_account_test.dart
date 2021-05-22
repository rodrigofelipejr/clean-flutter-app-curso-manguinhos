import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/domain/entities/account_entity.dart';

import 'local_load_current_account_test.mocks.dart';

abstract class FetchSecureCacheStorage {
  Future<String> fetchSecure(String key);
}

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({required this.fetchSecureCacheStorage});

  Future<AccountEntity> load() async {
    final token = await fetchSecureCacheStorage.fetchSecure('token');
    return AccountEntity(token);
  }
}

@GenerateMocks([], customMocks: [
  MockSpec<FetchSecureCacheStorage>(as: #FetchSecureCacheStorageMock, returnNullOnMissingStub: true),
])
main() {
  late FetchSecureCacheStorageMock fetchSecureCacheStorage;
  late LocalLoadCurrentAccount sut;
  late String key;
  late String token;

  void mockFetchSecure() {
    when(fetchSecureCacheStorage.fetchSecure(any)).thenAnswer((_) async => token);
  }

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageMock();
    sut = LocalLoadCurrentAccount(fetchSecureCacheStorage: fetchSecureCacheStorage);
    key = 'token';
    token = faker.guid.guid();
    mockFetchSecure();
  });

  test('Should call FetchSecureCacheStorage with correct value', () async {
    await sut.load();
    verify(fetchSecureCacheStorage.fetchSecure(key)).called(1);
  });

  test('Should return an AccountEntity', () async {
    final account = await sut.load();
    expect(account, AccountEntity(token));
  });
}
