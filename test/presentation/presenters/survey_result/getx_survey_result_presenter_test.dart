import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/presentation/presenters/presenters.dart';

import 'getx_survey_result_presenter_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<LoadSurveyResult>(as: #LoadSurveyResultMock)])
main() {
  late LoadSurveyResultMock loadSurveyResult;
  late GetXSurveyResultPresenter sut;
  late SurveyResultEntity surveyResult;
  late String surveyId;

  SurveyResultEntity mockValidData() => SurveyResultEntity(
        surveyId: faker.guid.guid(),
        question: faker.lorem.sentence(),
        answers: [
          SurveyAnswerEntity(
            image: faker.internet.httpUrl(),
            answer: faker.lorem.sentence(),
            isCurrentAnswer: faker.randomGenerator.boolean(),
            percent: faker.randomGenerator.integer(100),
          ),
          SurveyAnswerEntity(
            answer: faker.lorem.sentence(),
            isCurrentAnswer: faker.randomGenerator.boolean(),
            percent: faker.randomGenerator.integer(100),
          ),
        ],
      );

  PostExpectation mockLoadSurveyResultCall() => when(loadSurveyResult.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockLoadSurveyResult(SurveyResultEntity data) {
    surveyResult = data;
    mockLoadSurveyResultCall().thenAnswer((_) async => surveyResult);
  }

  void mockLoadSurveyResultError(DomainError error) => mockLoadSurveyResultCall().thenThrow(error);

  setUp(() {
    surveyId = faker.randomGenerator.string(50);
    loadSurveyResult = LoadSurveyResultMock();
    sut = GetXSurveyResultPresenter(
      loadSurveyResult: loadSurveyResult,
      surveyId: surveyId,
    );
    mockLoadSurveyResult(mockValidData());
  });

  test('Should call LoadSurveyResult on loadData', () async {
    await sut.loadData();
    verify(loadSurveyResult.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should emit correct event on success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveyResultStream.listen(
      expectAsync1(
        (survey) => expect(
          survey,
          SurveyResultViewModel(
            surveysId: surveyResult.surveyId,
            question: surveyResult.question,
            answers: [
              SurveyAnswerViewModel(
                image: surveyResult.answers[0].image,
                answer: surveyResult.answers[0].answer,
                isCurrentAnswer: surveyResult.answers[0].isCurrentAnswer,
                percent: '${surveyResult.answers[0].percent}%',
              ),
              SurveyAnswerViewModel(
                answer: surveyResult.answers[1].answer,
                isCurrentAnswer: surveyResult.answers[1].isCurrentAnswer,
                percent: '${surveyResult.answers[1].percent}%',
              ),
            ],
          ),
        ),
      ),
    );

    await sut.loadData();
  });

  test('Should emit correct event on failure', () async {
    mockLoadSurveyResultError(DomainError.unexpected);
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveyResultStream.listen(
      null,
      onError: expectAsync1((error) => expect(error, UiError.unexpected.description)),
    );

    await sut.loadData();
  });

  test('Should emit correct event on acesses denied', () async {
    mockLoadSurveyResultError(DomainError.accessDenied);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.isSessionExpiredStream, emits(true));

    await sut.loadData();
  });
}
