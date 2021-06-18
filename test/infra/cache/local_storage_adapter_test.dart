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

  setUp(() {
    localStorage = LocalStorageMock();
    sut = LocalStorageAdapter(localStorage);
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(50);
  });

  test('Should call localStorage with correct values', () async {
    await sut.save(key: key, value: value);
    verify(localStorage.deleteItem(key)).called(1);
    verify(localStorage.setItem(key, value)).called(1);
  });
}
