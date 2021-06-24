import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecases.dart';

import 'remote_load_survey_result_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<HttpClient>(as: #HttpClientMock)])
void main() {
  late RemoteLoadSurveyResult sut;
  late HttpClientMock httpClient;
  late String url;
  late Map surveyResult;

  //NOTE - mock - Resposta da API
  Map mockValidData() => {
        'surveyId': faker.guid.guid(),
        'question': faker.randomGenerator.string(50),
        'answers': [
          {
            'image': faker.internet.httpUrl(),
            'answer': faker.randomGenerator.string(20),
            'percent': faker.randomGenerator.integer(100),
            'count': faker.randomGenerator.integer(10000),
            'isCurrentAnswer': faker.randomGenerator.boolean(),
          },
          {
            'answer': faker.randomGenerator.string(20),
            'percent': faker.randomGenerator.integer(100),
            'count': faker.randomGenerator.integer(10000),
            'isCurrentAnswer': faker.randomGenerator.boolean(),
          }
        ],
        'date': faker.date.dateTime().toIso8601String(),
      };

  PostExpectation mockRequest() => when(httpClient.request(url: anyNamed('url'), method: anyNamed('method')));

  void mockHttpData(Map data) {
    surveyResult = data;
    return mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) => mockRequest().thenThrow(error);

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientMock();
    sut = RemoteLoadSurveyResult(httpClient: httpClient, url: url);
    mockHttpData(mockValidData());
  });

  test('Should call HttpClient with correct values', () async {
    await sut.loadBySurvey();
    verify(httpClient.request(url: url, method: 'get')).called(1);
  }, skip: true);

  test('Should return surveyResult on 200', () async {
    final result = await sut.loadBySurvey();

    expect(
        result,
        SurveyResultEntity(
          surveysId: surveyResult['surveyId'],
          question: surveyResult['question'],
          answers: [
            SurveyAnswerEntity(
              image: surveyResult['answers'][0]['image'],
              answer: surveyResult['answers'][0]['answer'],
              isCurrentAnswer: surveyResult['answers'][0]['isCurrentAnswer'].toString(),
              percent: surveyResult['answers'][0]['percent'],
            ),
            SurveyAnswerEntity(
              answer: surveyResult['answers'][1]['answer'],
              isCurrentAnswer: surveyResult['answers'][1]['isCurrentAnswer'].toString(),
              percent: surveyResult['answers'][1]['percent'],
            ),
          ],
        ));
  }, skip: true);

  test('Should throw UnexpectedError if HttpClient return 200 with invalid data', () async {
    mockHttpData({'invalid_key': 'invalid_value'});

    final future = sut.loadBySurvey();
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient return 404', () async {
    mockHttpError(HttpError.notFound);
    final future = sut.loadBySurvey();
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient return 500', () async {
    mockHttpError(HttpError.serverError);
    final future = sut.loadBySurvey();
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw AccessDeniedError if HttpClient return 403', () async {
    mockHttpError(HttpError.forbidden);
    final future = sut.loadBySurvey();
    expect(future, throwsA(DomainError.accessDenied));
  });
}
