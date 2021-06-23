import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/shared/routes/routes.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/presentation/presenters/presenters.dart';

import 'getx_surveys_presenter_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<LoadSurveys>(as: #LoadSurveysMock)])
main() {
  late LoadSurveysMock loadSurveys;
  late GetXSurveysPresenter sut;
  late List<SurveyEntity> surveys;

  PostExpectation mockLoadSurveysCall() => when(loadSurveys.load());

  List<SurveyEntity> mockValidData() => [
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.lorem.sentence(),
          dateTime: DateTime(2021, 2, 20),
          didAnswer: true,
        ),
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.lorem.sentence(),
          dateTime: DateTime(2018, 2, 8),
          didAnswer: true,
        ),
      ];

  void mockLoadSurveys(List<SurveyEntity> data) {
    surveys = data;
    mockLoadSurveysCall().thenAnswer((_) async => surveys);
  }

  void mockLoadSurveysError(DomainError error) => mockLoadSurveysCall().thenThrow(error);

  setUp(() {
    loadSurveys = LoadSurveysMock();
    sut = GetXSurveysPresenter(loadSurveys: loadSurveys);
    mockLoadSurveys(mockValidData());
  });

  test('Should call LoadSurveys on loadData', () async {
    await sut.loadData();
    verify(loadSurveys.load()).called(1);
  });

  test('Should emit correct event on success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveysStream.listen(
      expectAsync1(
        (surveys) => expect(surveys, [
          SurveyViewModel(
            id: surveys[0].id,
            question: surveys[0].question,
            date: '20 Fev 2021',
            didAnswer: surveys[0].didAnswer,
          ),
          SurveyViewModel(
            id: surveys[1].id,
            question: surveys[1].question,
            date: '8 Fev 2018',
            didAnswer: surveys[1].didAnswer,
          ),
        ]),
      ),
    );

    await sut.loadData();
  });

  test('Should emit correct event on failure', () async {
    mockLoadSurveysError(DomainError.unexpected);
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveysStream.listen(
      null,
      onError: expectAsync1((error) => expect(error, UiError.unexpected.description)),
    );

    await sut.loadData();
  });

  test('Should emit correct event on acesses denied', () async {
    mockLoadSurveysError(DomainError.accessDenied);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.isSessionExpiredStream, emits(true));

    await sut.loadData();
  });

  test('Should go to SurveyResultPage on survey click', () async {
    //NOTE - Como estamos testando streams o o teste deve ficar antes da chamada
    sut.navigateToStream.listen(expectAsync1((page) => '${AppRoutes.surveyResult}/any_route'));
    sut.goToSurveyResult('any_route');
  });
}
