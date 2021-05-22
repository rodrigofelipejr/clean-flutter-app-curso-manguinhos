import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import 'local_save_current_account_test.mocks.dart';

abstract class SaveSecureCacheStorage {
  Future<void> saveSecure({required String key, required String value});
}

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({required this.saveSecureCacheStorage});
  @override
  Future<void> save(AccountEntity account) async {
    try {
      await saveSecureCacheStorage.saveSecure(key: 'token', value: account.token);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}

@GenerateMocks([],
    customMocks: [MockSpec<SaveSecureCacheStorage>(as: #SaveSecureCacheStorageMock, returnNullOnMissingStub: true)])
main() {
  late LocalSaveCurrentAccount sut;
  late SaveSecureCacheStorageMock saveSecureCacheStorage;
  late AccountEntity account;

  setUp(() {
    saveSecureCacheStorage = SaveSecureCacheStorageMock();
    sut = LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    account = AccountEntity(faker.guid.guid());
  });

  test('Should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(account);
    verify(saveSecureCacheStorage.saveSecure(key: 'token', value: account.token)).called(1);
  });

  test('Should throw UnexpectedError if SaveSecureCacheStorage throws', () async {
    when(saveSecureCacheStorage.saveSecure(key: anyNamed('key'), value: anyNamed('value'))).thenThrow(Exception());

    final future = sut.save(account);
    expect(future, throwsA(DomainError.unexpected));
  });
}
