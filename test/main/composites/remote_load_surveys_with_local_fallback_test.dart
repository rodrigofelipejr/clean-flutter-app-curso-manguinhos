import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/domain/entities/survey_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/main/composites/composites.dart';

import 'remote_load_surveys_with_local_fallback_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<RemoteLoadSurveys>(as: #RemoteLoadSurveysMock, returnNullOnMissingStub: true),
  MockSpec<LocalLoadSurveys>(as: #LocalLoadSurveysMock, returnNullOnMissingStub: true),
])
main() {
  late RemoteLoadSurveysWithLocalFallback sut;
  late RemoteLoadSurveysMock remote;
  late List<SurveyEntity> remoteSurveys;
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

  mockRemoteLoad() {
    remoteSurveys = mockSurveys();
    when(remote.load()).thenAnswer((_) async => remoteSurveys);
  }

  setUp(() {
    remote = RemoteLoadSurveysMock();
    local = LocalLoadSurveysMock();
    sut = RemoteLoadSurveysWithLocalFallback(remoteLoadSurveys: remote, localLoadSurveys: local);
    mockRemoteLoad();
  });

  test('Should call remote load', () async {
    await sut.load();
    verify(remote.load()).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.load();
    verify(local.save(remoteSurveys)).called(1);
  });

  test('Should return remote data', () async {
    final surveys = await sut.load();
    expect(surveys, remoteSurveys);
  });
}
