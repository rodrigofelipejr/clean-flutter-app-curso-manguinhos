import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/entities/survey_entity.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/data/cache/cache.dart';

import 'local_load_surveys_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<CacheStorage>(as: #CacheStorageMock),
])
void main() {
  late LocalLoadSurveys sut;
  late CacheStorageMock cacheStorage;
  late List<Map> data;

  List<Map> mockValidData() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': '2021-06-16T00:00:00Z',
          'didAnswer': 'false',
        },
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': '2021-03-06T00:00:00Z',
          'didAnswer': 'true',
        }
      ];

  PostExpectation mockFetchCall() => when(cacheStorage.fetch(any));

  void mockFetch(List<Map> list) {
    data = list;
    mockFetchCall().thenAnswer((_) async => data);
  }

  void mockFetchError() => mockFetchCall().thenThrow(Exception());

  setUp(() {
    cacheStorage = CacheStorageMock();
    sut = LocalLoadSurveys(cacheStorage: cacheStorage);
    mockFetch(mockValidData());
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
    mockFetch([
      {
        'id': faker.guid.guid(),
        'question': faker.randomGenerator.string(10),
        'date': 'invalid data',
        'didAnswer': 'false',
      },
    ]);
    final future = sut.load();
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if cache is incomplete', () async {
    mockFetch([
      {
        'date': '2021-06-16T00:00:00Z',
        'didAnswer': 'false',
      },
    ]);
    final future = sut.load();
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if cache throws', () async {
    mockFetchError();
    final future = sut.load();
    expect(future, throwsA(DomainError.unexpected));
  });
}
