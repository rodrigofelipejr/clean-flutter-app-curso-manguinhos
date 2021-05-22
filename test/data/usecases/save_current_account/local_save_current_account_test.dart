import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'local_save_current_account_test.mocks.dart';

abstract class SaveSecureCacheStorage {
  Future<void> saveSecure({required String key, required String value});
}

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({required this.saveSecureCacheStorage});
  @override
  Future<void> save(AccountEntity account) async {
    await saveSecureCacheStorage.saveSecure(key: 'token', value: account.token);
  }
}

@GenerateMocks([], customMocks: [MockSpec<SaveSecureCacheStorage>(as: #SaveSecureCacheStorageMock)])
main() {
  test('Should call SaveCacheStorage with correct values', () async {
    final saveSecureCacheStorage = SaveSecureCacheStorageMock();
    final sut = LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    final account = AccountEntity(faker.guid.guid());

    await sut.save(account);
    verify(saveSecureCacheStorage.saveSecure(key: 'token', value: account.token)).called(1);
  });
}
