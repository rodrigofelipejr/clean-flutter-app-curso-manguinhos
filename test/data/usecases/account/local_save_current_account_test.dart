import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/usecases/usecases.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';

import 'local_save_current_account_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<SaveSecureCacheStorage>(as: #SaveSecureCacheStorageMock, returnNullOnMissingStub: true),
])
main() {
  late LocalSaveCurrentAccount sut;
  late SaveSecureCacheStorageMock saveSecureCacheStorage;
  late AccountEntity account;

  setUp(() {
    saveSecureCacheStorage = SaveSecureCacheStorageMock();
    sut = LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    account = AccountEntity(faker.guid.guid());
  });

  void mockError() {
    when(saveSecureCacheStorage.save(key: anyNamed('key'), value: anyNamed('value'))).thenThrow(Exception());
  }

  test('Should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(account);
    verify(saveSecureCacheStorage.save(key: 'token', value: account.token)).called(1);
  });

  test('Should throw UnexpectedError if SaveSecureCacheStorage throws', () async {
    mockError();
    final future = sut.save(account);
    expect(future, throwsA(DomainError.unexpected));
  });
}
