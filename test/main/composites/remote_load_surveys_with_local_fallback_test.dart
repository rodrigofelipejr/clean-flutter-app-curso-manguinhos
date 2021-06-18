import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/entities/survey_entity.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/main/composites/composites.dart';

import 'remote_load_surveys_with_local_fallback_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<RemoteLoadSurveys>(as: #RemoteLoadSurveysMock),
  MockSpec<LocalLoadSurveys>(as: #LocalLoadSurveysMock),
])
main() {
  late RemoteLoadSurveysWithLocalFallback sut;
  late RemoteLoadSurveysMock remote;
  late List<SurveyEntity> remoteSurveys;
  late List<SurveyEntity> localSurveys;
  late LocalLoadSurveysMock local;

  List<SurveyEntity> mockSurveys() => [
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.randomGenerator.string(10),
          dateTime: faker.date.dateTime(),
          didAnswer: faker.randomGenerator.boolean(),
        ),
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.randomGenerator.string(10),
          dateTime: faker.date.dateTime(),
          didAnswer: faker.randomGenerator.boolean(),
        ),
      ];

  PostExpectation mockRemoteLoadCall() => when(remote.load());

  mockRemoteLoad() {
    remoteSurveys = mockSurveys();
    mockRemoteLoadCall().thenAnswer((_) async => remoteSurveys);
  }

  mockRemoteLoadError(DomainError error) => mockRemoteLoadCall().thenThrow(error);

  PostExpectation mockLocalLoadCall() => when(local.load());

  mockLocalLoad() {
    localSurveys = mockSurveys();
    mockLocalLoadCall().thenAnswer((_) async => localSurveys);
  }

  setUp(() {
    remote = RemoteLoadSurveysMock();
    local = LocalLoadSurveysMock();
    sut = RemoteLoadSurveysWithLocalFallback(remoteLoadSurveys: remote, localLoadSurveys: local);
    mockRemoteLoad();
    mockLocalLoad();
  });

  test('Should call remote load', () async {
    await sut.load();
    verify(remote.load()).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.load();
    verify(local.save(remoteSurveys)).called(1);
  });

  test('Should return remote surveys', () async {
    final surveys = await sut.load();
    expect(surveys, remoteSurveys);
  });

  test('Should rethrow if remote load throws AccessDeniedError', () async {
    mockRemoteLoadError(DomainError.accessDenied);
    final future = sut.load();
    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should call local fetch on remote error', () async {
    mockRemoteLoadError(DomainError.unexpected);
    await sut.load();
    verify(local.validate()).called(1);
    verify(local.load()).called(1);
  });

  test('Should return local surveys', () async {
    mockRemoteLoadError(DomainError.unexpected);
    final surveys = await sut.load();
    expect(surveys, localSurveys);
  });
}
