import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/usecases/usecases.dart';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/entities/account_entity.dart';

import 'local_load_current_account_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<FetchSecureCacheStorage>(as: #FetchSecureCacheStorageMock, returnNullOnMissingStub: true),
])
main() {
  late FetchSecureCacheStorageMock fetchSecureCacheStorage;
  late LocalLoadCurrentAccount sut;
  late String key;
  late String token;

  PostExpectation mockFetchSecureCall() => when(fetchSecureCacheStorage.fetchSecure(any));

  void mockFetchSecure() {
    mockFetchSecureCall().thenAnswer((_) async => token);
  }

  void mockFetchSecureError() {
    mockFetchSecureCall().thenThrow(Exception());
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

  test('Should throw UnexpectedError if FetchSecureCacheStorage throws', () async {
    mockFetchSecureError();
    final future = sut.load();
    expect(future, throwsA(DomainError.unexpected));
  });
}
