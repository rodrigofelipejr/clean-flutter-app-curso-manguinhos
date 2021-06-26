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
  late SurveyResultEntity remoteSurveyResult;
  late SurveyResultEntity localSurveyResult;

  SurveyResultEntity mockSurveyResultEntity() => SurveyResultEntity(
        surveyId: faker.guid.guid(),
        question: faker.lorem.sentence(),
        answers: [
          SurveyAnswerEntity(
              answer: faker.lorem.sentence(),
              isCurrentAnswer: faker.randomGenerator.boolean(),
              percent: faker.randomGenerator.integer(100)),
        ],
      );

  PostExpectation mockRemoteLoadCall() => when(remote.loadBySurvey(surveyId: anyNamed('surveyId')));

  PostExpectation mockLocalLoadCall() => when(local.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockRemoteLoad() {
    remoteSurveyResult = mockSurveyResultEntity();
    mockRemoteLoadCall().thenAnswer((_) async => remoteSurveyResult);
  }

  void mockLocalLoad() {
    localSurveyResult = mockSurveyResultEntity();
    mockLocalLoadCall().thenAnswer((_) async => localSurveyResult);
  }

  void mockRemoteLoadError(DomainError error) => mockRemoteLoadCall().thenThrow(error);
  void mockLocalLoadError() => mockLocalLoadCall().thenThrow(DomainError.unexpected);

  setUp(() {
    remote = RemoteLoadSurveyResultMock();
    local = LocalLoadSurveyResultMock();
    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remote, local: local);
    surveyId = faker.guid.guid();

    mockRemoteLoad();
    mockLocalLoad();
  });

  test('Should call remote LoadBySurvey', () async {
    await sut.loadBySurvey(surveyId: surveyId);
    verify(remote.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should call local save data', () async {
    await sut.loadBySurvey(surveyId: surveyId);
    verify(local.save(remoteSurveyResult)).called(1);
  });

  test('Should return remote data', () async {
    final response = await sut.loadBySurvey(surveyId: surveyId);
    expect(response, remoteSurveyResult);
  });

  test('Should rethrow if remote LoadBySurvey throws AccessDeniedError', () async {
    mockRemoteLoadError(DomainError.accessDenied);
    final future = sut.loadBySurvey(surveyId: surveyId);
    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should call LoadBySurvey on remote error', () async {
    mockRemoteLoadError(DomainError.unexpected);
    await sut.loadBySurvey(surveyId: surveyId);
    verify(local.validate(surveyId)).called(1);
    verify(local.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should return local data', () async {
    mockRemoteLoadError(DomainError.unexpected);
    final response = await sut.loadBySurvey(surveyId: surveyId);
    expect(response, localSurveyResult);
  });

  test('Should throw Unexpected if local load fails', () async {
    mockRemoteLoadError(DomainError.unexpected);
    mockLocalLoadError();

    final future = sut.loadBySurvey(surveyId: surveyId);
    expect(future, throwsA(DomainError.unexpected));
  });
}
