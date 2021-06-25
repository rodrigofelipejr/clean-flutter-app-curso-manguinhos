import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/main/composites/composites.dart';

import 'remote_load_survey_result_with_local_fallback_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<RemoteLoadSurveyResult>(as: #RemoteLoadSurveyResultMock),
  MockSpec<LocalLoadSurveyResult>(as: #LocalLoadSurveyResultMock),
])
main() {
  late RemoteLoadSurveyResultWithLocalFallback sut;
  late RemoteLoadSurveyResultMock remote;
  late LocalLoadSurveyResultMock local;
  late String surveyId;
  late SurveyResultEntity surveyResult;

  SurveyResultEntity mockSurveyResultEntity() => SurveyResultEntity(
        surveysId: faker.guid.guid(),
        question: faker.lorem.sentence(),
        answers: [
          SurveyAnswerEntity(
              answer: faker.lorem.sentence(),
              isCurrentAnswer: faker.randomGenerator.boolean(),
              percent: faker.randomGenerator.integer(100)),
        ],
      );

  PostExpectation mockRemoteLoadCall() => when(remote.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockRemoteLoad() {
    surveyResult = mockSurveyResultEntity();
    mockRemoteLoadCall().thenAnswer((_) async => surveyResult);
  }

  void mockRemoteLoadError(DomainError error) => mockRemoteLoadCall().thenThrow(error);

  setUp(() {
    remote = RemoteLoadSurveyResultMock();
    local = LocalLoadSurveyResultMock();
    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remote, local: local);
    surveyId = faker.guid.guid();

    mockRemoteLoad();
  });

  test('Should call remote LoadBySurvey', () async {
    await sut.loadBySurvey(surveyId: surveyId);
    verify(remote.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should call local save data', () async {
    await sut.loadBySurvey(surveyId: surveyId);
    verify(local.save(surveyId: surveyId, surveyResult: surveyResult)).called(1);
  });

  test('Should return remote data', () async {
    final response = await sut.loadBySurvey(surveyId: surveyId);
    expect(response, surveyResult);
  });

  test('Should rethrow if remote LoadBySurvey throws AccessDeniedError', () async {
    mockRemoteLoadError(DomainError.accessDenied);

    final future = sut.loadBySurvey(surveyId: surveyId);
    expect(future, throwsA(DomainError.accessDenied));
  });
}
