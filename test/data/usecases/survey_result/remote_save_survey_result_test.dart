import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecases.dart';

import '../../../mocks/survey_result/fake_survey_result_factory.dart';
import 'remote_load_survey_result_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<HttpClient>(as: #HttpClientMock)])
void main() {
  late RemoteSaveSurveyResult sut;
  late HttpClientMock httpClient;
  late String url;
  late String answer;
  late Map surveyResult;

  PostExpectation mockRequest() => when(httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
      ));

  void mockHttpData(Map data) {
    surveyResult = data;
    return mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) => mockRequest().thenThrow(error);

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientMock();
    answer = faker.lorem.sentence();
    sut = RemoteSaveSurveyResult(httpClient: httpClient, url: url);
    mockHttpData(FakeSurveyResultFactory.makeApiJson());
  });

  test('Should call HttpClient with correct values', () async {
    await sut.save(answer: answer);
    verify(httpClient.request(url: url, method: 'put', body: {'answer': answer})).called(1);
  });

  test('Should throw UnexpectedError if HttpClient return 404', () async {
    mockHttpError(HttpError.notFound);
    final future = sut.save(answer: answer);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should return surveyResult on 200', () async {
    final result = await sut.save(answer: answer);

    expect(
        result,
        SurveyResultEntity(
          surveyId: surveyResult['surveyId'],
          question: surveyResult['question'],
          answers: [
            SurveyAnswerEntity(
              image: surveyResult['answers'][0]['image'],
              answer: surveyResult['answers'][0]['answer'],
              isCurrentAnswer: surveyResult['answers'][0]['isCurrentAccountAnswer'],
              percent: surveyResult['answers'][0]['percent'],
            ),
            SurveyAnswerEntity(
              answer: surveyResult['answers'][1]['answer'],
              isCurrentAnswer: surveyResult['answers'][1]['isCurrentAccountAnswer'],
              percent: surveyResult['answers'][1]['percent'],
            ),
          ],
        ));
  });

  test('Should throw UnexpectedError if HttpClient return 200 with invalid data', () async {
    mockHttpData(FakeSurveyResultFactory.makeInvalidApiJson());

    final future = sut.save(answer: answer);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient return 500', () async {
    mockHttpError(HttpError.serverError);
    final future = sut.save(answer: answer);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw AccessDeniedError if HttpClient return 403', () async {
    mockHttpError(HttpError.forbidden);
    final future = sut.save(answer: answer);
    expect(future, throwsA(DomainError.accessDenied));
  });
}
