import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/entities/survey_entity.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/data/cache/cache.dart';

import '../../../mocks/mocks.dart';
import 'local_load_surveys_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<CacheStorage>(as: #CacheStorageMock),
])
void main() {
  group('Load', () {
    late LocalLoadSurveys sut;
    late CacheStorageMock cacheStorage;
    late List<Map> data;

    PostExpectation mockFetchCall() => when(cacheStorage.fetch(any));

    void mockFetch(List<Map> list) {
      data = list;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageMock();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);
      mockFetch(FakeSurveyFactory.makeCacheJson());
    });

    test('Should call CacheStorage with correct key', () async {
      await sut.load();
      verify(cacheStorage.fetch('surveys')).called(1);
    });
    test('Should return a list of surveys on success', () async {
      final surveys = await sut.load();

      expect(surveys, [
        SurveyEntity(
          id: data[0]['id'],
          question: data[0]['question'],
          dateTime: DateTime.utc(2021, 6, 16),
          didAnswer: false,
        ),
        SurveyEntity(
          id: data[1]['id'],
          question: data[1]['question'],
          dateTime: DateTime.utc(2021, 3, 6),
          didAnswer: true,
        ),
      ]);
    });

    test('Should throw UnexpectedError if cache is empty', () async {
      mockFetch([]);
      final future = sut.load();
      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is invalid', () async {
      mockFetch(FakeSurveyFactory.makeInvalidCacheJson());
      final future = sut.load();
      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is incomplete', () async {
      mockFetch(FakeSurveyFactory.makeIncompleteCacheJson());
      final future = sut.load();
      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache throws', () async {
      mockFetchError();
      final future = sut.load();
      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('Validate', () {
    late LocalLoadSurveys sut;
    late CacheStorageMock cacheStorage;
    late List<Map> data;

    PostExpectation mockFetchCall() => when(cacheStorage.fetch(any));

    void mockFetch(List<Map> list) {
      data = list;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageMock();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);
      mockFetch(FakeSurveyFactory.makeCacheJson());
    });

    test('Should call CacheStorage with correct key', () async {
      await sut.validate();
      verify(cacheStorage.fetch('surveys')).called(1);
    });

    test('Should delete cache if it is invalid', () async {
      mockFetch(FakeSurveyFactory.makeInvalidCacheJson());

      await sut.validate();
      verify(cacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache if it is incomplete', () async {
      mockFetch(FakeSurveyFactory.makeIncompleteCacheJson());

      await sut.validate();
      verify(cacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache if fetch fails throws', () async {
      mockFetchError();

      await sut.validate();
      verify(cacheStorage.delete('surveys')).called(1);
    });
  });

  group('Save', () {
    late LocalLoadSurveys sut;
    late CacheStorageMock cacheStorage;
    late List<SurveyEntity> surveys;

    PostExpectation mockSaveCall() => when(cacheStorage.save(key: anyNamed('key'), value: anyNamed('value')));

    void mockSaveError() => mockSaveCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageMock();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);
      surveys = FakeSurveyFactory.makeEntities();
    });

    test('Should call CacheStorage with correct values', () async {
      final list = [
        {
          'id': surveys[0].id,
          'question': surveys[0].question,
          'date': '2021-06-16T00:00:00.000Z',
          'didAnswer': 'false',
        },
        {
          'id': surveys[1].id,
          'question': surveys[1].question,
          'date': '2021-06-17T00:00:00.000Z',
          'didAnswer': 'true',
        },
      ];

      await sut.save(surveys);
      verify(cacheStorage.save(key: 'surveys', value: list)).called(1);
    });

    test('Should throw UnexpectedError if save throws', () async {
      mockSaveError();
      final future = sut.save(surveys);
      expect(future, throwsA(DomainError.unexpected));
    });
  });
}
