import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/entities/survey_answer_entity.dart';
import 'package:fordev/shared/routes/routes.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/data/cache/cache.dart';

import '../../../mocks/mocks.dart';
import 'local_load_survey_result_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<CacheStorage>(as: #CacheStorageMock),
])
void main() {
  group('LoadBySurvey', () {
    late LocalLoadSurveyResult sut;
    late CacheStorageMock cacheStorage;
    late Map data;
    late String surveyId;

    PostExpectation mockFetchCall() => when(cacheStorage.fetch(any));

    void mockFetch(Map json) {
      data = json;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageMock();
      sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);
      surveyId = faker.guid.guid();
      mockFetch(FakeSurveyResultFactory.makeCacheJson());
    });

    test('Should call CacheStorage with correct key', () async {
      await sut.loadBySurvey(surveyId: surveyId);
      verify(cacheStorage.fetch('${AppRoutes.surveyResult}/$surveyId')).called(1);
    });

    test('Should return surveyResult on success', () async {
      final surveys = await sut.loadBySurvey(surveyId: surveyId);

      expect(
        surveys,
        SurveyResultEntity(
          surveyId: data['surveyId'],
          question: data['question'],
          answers: [
            SurveyAnswerEntity(
              image: data['answers'][0]['image'],
              answer: data['answers'][0]['answer'],
              isCurrentAnswer: true,
              percent: 40,
            ),
            SurveyAnswerEntity(
              answer: data['answers'][1]['answer'],
              isCurrentAnswer: false,
              percent: 60,
            ),
          ],
        ),
      );
    });

    test('Should throw UnexpectedError if cache is empty', () async {
      mockFetch({});
      final future = sut.loadBySurvey(surveyId: surveyId);
      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is invalid', () async {
      mockFetch(FakeSurveyResultFactory.makeInvalidCacheJson());
      final future = sut.loadBySurvey(surveyId: surveyId);
      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is incomplete', () async {
      mockFetch(FakeSurveyResultFactory.makeIncompleteCacheJson());
      final future = sut.loadBySurvey(surveyId: surveyId);
      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache throws', () async {
      mockFetchError();
      final future = sut.loadBySurvey(surveyId: surveyId);
      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('Validate', () {
    late LocalLoadSurveyResult sut;
    late CacheStorageMock cacheStorage;
    late Map data;
    late String surveyId;

    PostExpectation mockFetchCall() => when(cacheStorage.fetch(any));

    void mockFetch(Map json) {
      data = json;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      surveyId = faker.guid.guid();
      cacheStorage = CacheStorageMock();
      sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);
      mockFetch(FakeSurveyResultFactory.makeCacheJson());
    });

    test('Should call CacheStorage with correct key', () async {
      await sut.validate(surveyId);
      verify(cacheStorage.fetch('${AppRoutes.surveyResult}/$surveyId')).called(1);
    });

    test('Should delete cache if it is invalid', () async {
      mockFetch(FakeSurveyResultFactory.makeInvalidCacheJson());

      await sut.validate(surveyId);
      verify(cacheStorage.delete('${AppRoutes.surveyResult}/$surveyId')).called(1);
    });

    test('Should delete cache if it is incomplete', () async {
      mockFetch(FakeSurveyResultFactory.makeIncompleteCacheJson());

      await sut.validate(surveyId);
      verify(cacheStorage.delete('${AppRoutes.surveyResult}/$surveyId')).called(1);
    });

    test('Should delete cache if fetch fails', () async {
      mockFetchError();

      await sut.validate(surveyId);
      verify(cacheStorage.delete('${AppRoutes.surveyResult}/$surveyId')).called(1);
    });
  });

  group('Save', () {
    late LocalLoadSurveyResult sut;
    late CacheStorageMock cacheStorage;
    late SurveyResultEntity surveyResult;

    PostExpectation mockSaveCall() => when(cacheStorage.save(key: anyNamed('key'), value: anyNamed('value')));

    void mockSaveError() => mockSaveCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageMock();
      sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);
      surveyResult = FakeSurveyResultFactory.makeEntity();
    });

    test('Should call CacheStorage with correct values', () async {
      final json = {
        'surveyId': surveyResult.surveyId,
        'question': surveyResult.question,
        'answers': [
          {
            'image': surveyResult.answers[0].image,
            'answer': surveyResult.answers[0].answer,
            'isCurrentAccountAnswer': 'true',
            'percent': '40',
          },
          {
            'image': null,
            'answer': surveyResult.answers[1].answer,
            'isCurrentAccountAnswer': 'false',
            'percent': '60',
          },
        ],
      };

      await sut.save(surveyResult);
      verify(cacheStorage.save(key: '${AppRoutes.surveyResult}/${surveyResult.surveyId}', value: json)).called(1);
    });

    test('Should throw UnexpectedError if save throws', () async {
      mockSaveError();
      final future = sut.save(surveyResult);
      expect(future, throwsA(DomainError.unexpected));
    });
  });
}
