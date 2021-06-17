import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'local_load_surveys_test.mocks.dart';

class LocalLoadSurveys {
  final FetchCacheStorage fetchCacheStorage;

  LocalLoadSurveys({required this.fetchCacheStorage});

  Future<void> load() async {
    fetchCacheStorage.fetch('surveys');
  }
}

abstract class FetchCacheStorage {
  Future<void> fetch(String key);
}

@GenerateMocks([], customMocks: [
  MockSpec<FetchCacheStorage>(as: #FetchCacheStorageMock, returnNullOnMissingStub: true),
])
void main() {
  late LocalLoadSurveys sut;
  late FetchCacheStorageMock fetchCacheStorage;

  setUp(() {
    fetchCacheStorage = FetchCacheStorageMock();
    sut = LocalLoadSurveys(fetchCacheStorage: fetchCacheStorage);
  });

  test('Should call FetchCacheStorage with correct key', () async {
    await sut.load();
    verify(fetchCacheStorage.fetch('surveys')).called(1);
  });
}
