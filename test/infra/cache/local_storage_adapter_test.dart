import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/infra/cache/cache.dart';

import 'local_storage_adapter_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<LocalStorage>(as: #LocalStorageMock),
])
main() {
  late LocalStorageAdapter sut;
  late LocalStorageMock localStorage;
  late String key;
  late dynamic value;
  late String result;

  void mockDeleteError() => when(localStorage.deleteItem(any)).thenThrow(Exception());

  void mockSaveError() => when(localStorage.setItem(any, any)).thenThrow(Exception());

  void mockReadCall() => when(localStorage.ready).thenAnswer((_) async => true);

  group('save', () {
    setUp(() {
      localStorage = LocalStorageMock();
      sut = LocalStorageAdapter(localStorage: localStorage);
      key = faker.randomGenerator.string(5);
      value = faker.randomGenerator.string(50);
      mockReadCall();
    });

    test('Should call localStorage with correct values', () async {
      await sut.save(key: key, value: value);

      verify(localStorage.ready).called(1);
      verify(localStorage.deleteItem(key)).called(1);
      verify(localStorage.setItem(key, value)).called(1);
    });

    test('Should throw if deleteItem throws', () async {
      mockDeleteError();
      final future = sut.save(key: key, value: value);
      expect(future, throwsA(TypeMatcher<Exception>()));
    });

    test('Should throw if setItem throws', () async {
      mockSaveError();
      final future = sut.save(key: key, value: value);
      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('delete', () {
    setUp(() {
      localStorage = LocalStorageMock();
      sut = LocalStorageAdapter(localStorage: localStorage);
      key = faker.randomGenerator.string(5);
      value = faker.randomGenerator.string(50);
      mockReadCall();
    });

    test('Should call localStorage with correct values', () async {
      await sut.delete(key);

      verify(localStorage.ready).called(1);
      verify(localStorage.deleteItem(key)).called(1);
    });

    test('Should throw if deleteItem throws', () async {
      mockDeleteError();
      final future = sut.delete(key);
      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('fetch', () {
    PostExpectation mockCall() => when(localStorage.getItem(any));

    void mockFetch() {
      result = faker.randomGenerator.string(50);
      return mockCall().thenAnswer((realInvocation) async => result);
    }

    void mockFetchError() => mockCall().thenThrow(Exception());

    setUp(() {
      localStorage = LocalStorageMock();
      sut = LocalStorageAdapter(localStorage: localStorage);
      key = faker.randomGenerator.string(5);
      value = faker.randomGenerator.string(50);

      mockReadCall();
      mockFetch();
    });

    test('Should call localStorage with correct values', () async {
      await sut.fetch(key);

      verify(localStorage.ready).called(1);
      verify(localStorage.getItem(key)).called(1);
    });

    test('Should return same value as localStorage', () async {
      final data = await sut.fetch(key);
      expect(data, result);
    });

    test('Should throw if getItem throws', () async {
      mockFetchError();
      final future = sut.fetch(key);
      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });
}
