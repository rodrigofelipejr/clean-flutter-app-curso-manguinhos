import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/entities/survey_entity.dart';
import 'package:fordev/data/models/models.dart';

import 'local_load_surveys_test.mocks.dart';

class LocalLoadSurveys {
  final FetchCacheStorage fetchCacheStorage;

  LocalLoadSurveys({required this.fetchCacheStorage});

  Future<List<SurveyEntity>> load() async {
    final data = await fetchCacheStorage.fetch('surveys');
    if (data.isEmpty) throw DomainError.unexpected;
    return data.map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json).toEntity()).toList();
  }
}

abstract class FetchCacheStorage {
  Future<dynamic> fetch(String key);
}

@GenerateMocks([], customMocks: [
  MockSpec<FetchCacheStorage>(as: #FetchCacheStorageMock),
])
void main() {
  late LocalLoadSurveys sut;
  late FetchCacheStorageMock fetchCacheStorage;
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

  void mockFetch(List<Map> list) {
    data = list;
    when(fetchCacheStorage.fetch(any)).thenAnswer((_) async => data);
  }

  setUp(() {
    fetchCacheStorage = FetchCacheStorageMock();
    sut = LocalLoadSurveys(fetchCacheStorage: fetchCacheStorage);
    mockFetch(mockValidData());
  });

  test('Should call FetchCacheStorage with correct key', () async {
    await sut.load();
    verify(fetchCacheStorage.fetch('surveys')).called(1);
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
}
