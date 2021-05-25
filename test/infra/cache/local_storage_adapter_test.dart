import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/infra/cache/cache.dart';

import 'local_storage_adapter_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<FlutterSecureStorage>(as: #FlutterSecureStorageMock, returnNullOnMissingStub: true),
])
main() {
  late String key;
  late String value;
  late FlutterSecureStorageMock secureStorage;
  late LocalStorageAdapter sut;

  setUp(() {
    key = faker.lorem.word();
    value = faker.guid.guid();
    secureStorage = FlutterSecureStorageMock();
    sut = LocalStorageAdapter(secureStorage: secureStorage);
  });

  group('saveSecure', () {
    void mockSaveSecureError() {
      when(secureStorage.write(key: anyNamed('key'), value: anyNamed('value'))).thenThrow(Exception());
    }

    test('Should call save secure with correct values', () async {
      await sut.saveSecure(key: key, value: value);
      verify(secureStorage.write(key: key, value: value));
    });

    test('Should throw if save secure throw', () {
      mockSaveSecureError();
      final future = sut.saveSecure(key: key, value: value);
      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('fetchSecure', () {
    void mockFetchSecure() {
      when(secureStorage.read(key: anyNamed('key'))).thenAnswer((_) async => value);
    }

    setUp(() {
      mockFetchSecure();
    });

    test('Should call fetch secure with correct value', () async {
      await sut.fetchSecure(key);
      verify(secureStorage.read(key: key)).called(1);
    });

    test('Should return correct value on success', () async {
      final fetchedValue = await sut.fetchSecure(key);
      expect(fetchedValue, value);
    });
  });
}
