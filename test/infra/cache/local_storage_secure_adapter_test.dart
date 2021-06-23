import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/infra/cache/cache.dart';

import 'local_storage_secure_adapter_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<FlutterSecureStorage>(as: #FlutterSecureStorageMock, returnNullOnMissingStub: true),
])
main() {
  late String key;
  late String value;
  late FlutterSecureStorageMock secureStorage;
  late LocalStorageSecureAdapter sut;

  setUp(() {
    key = faker.lorem.word();
    value = faker.guid.guid();
    secureStorage = FlutterSecureStorageMock();
    sut = LocalStorageSecureAdapter(secureStorage: secureStorage);
  });

  group('SaveSecure', () {
    void mockSaveSecureError() {
      when(secureStorage.write(key: anyNamed('key'), value: anyNamed('value'))).thenThrow(Exception());
    }

    test('Should call save secure with correct values', () async {
      await sut.save(key: key, value: value);
      verify(secureStorage.write(key: key, value: value));
    });

    test('Should throw if save secure throw', () {
      mockSaveSecureError();
      final future = sut.save(key: key, value: value);
      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('FetchSecure', () {
    PostExpectation mockFetchSecureCall() => when(secureStorage.read(key: anyNamed('key')));

    void mockFetchSecure() => mockFetchSecureCall().thenAnswer((_) async => value);
    void mockFetchSecureError() => mockFetchSecureCall().thenThrow(Exception());

    setUp(() {
      mockFetchSecure();
    });

    test('Should call fetch secure with correct value', () async {
      await sut.fetch(key);
      verify(secureStorage.read(key: key)).called(1);
    });

    test('Should return correct value on success', () async {
      final fetchedValue = await sut.fetch(key);
      expect(fetchedValue, value);
    });

    test('Should throw if fetch secure throw', () {
      mockFetchSecureError();
      final future = sut.fetch(key);
      expect(future, throwsA(TypeMatcher<Exception>()));
    });

    test('Should return empty if no value for key fetched from secure storage is found', () async {
      mockFetchSecureCall().thenAnswer((_) async => null);
      final result = await sut.fetch(key);
      expect(result, isEmpty);
    });
  });

  group('Delete', () {
    void mockDeleteSecureError() => when(secureStorage.delete(key: anyNamed('key'))).thenThrow(Exception());

    test('Should call delete with correct key', () async {
      await sut.delete(key);

      verify(secureStorage.delete(key: key)).called(1);
    });

    test('Should throw if delete throws', () async {
      mockDeleteSecureError();
      final future = sut.delete(key);
      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });
}
