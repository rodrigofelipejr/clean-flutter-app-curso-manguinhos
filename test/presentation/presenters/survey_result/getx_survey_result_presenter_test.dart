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

@GenerateMocks(
  [],
  customMocks: [
    MockSpec<LoadSurveyResult>(as: #LoadSurveyResultMock),
    MockSpec<SaveSurveyResult>(as: #SaveSurveyResultMock),
  ],
)
main() {
  late LoadSurveyResultMock loadSurveyResult;
  late SaveSurveyResultMock saveSurveyResult;
  late GetXSurveyResultPresenter sut;
  late SurveyResultEntity loadResult;
  late SurveyResultEntity saveResult;
  late String surveyId;
  late String answer;

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
    loadResult = data;
    mockLoadSurveyResultCall().thenAnswer((_) async => loadResult);
  }

  void mockLoadSurveyResultError(DomainError error) => mockLoadSurveyResultCall().thenThrow(error);

  PostExpectation mockSaveSurveyResultCall() => when(saveSurveyResult.save(answer: anyNamed('answer')));

  void mockSaveSurveyResult(SurveyResultEntity data) {
    saveResult = data;
    mockSaveSurveyResultCall().thenAnswer((_) async => saveResult);
  }

  void mockSaveSurveyResultError(DomainError error) => mockSaveSurveyResultCall().thenThrow(error);

  SurveyResultViewModel mapToViewModel(SurveyResultEntity entity) => SurveyResultViewModel(
        surveysId: entity.surveyId,
        question: entity.question,
        answers: [
          SurveyAnswerViewModel(
            image: entity.answers[0].image,
            answer: entity.answers[0].answer,
            isCurrentAnswer: entity.answers[0].isCurrentAnswer,
            percent: '${entity.answers[0].percent}%',
          ),
          SurveyAnswerViewModel(
            answer: entity.answers[1].answer,
            isCurrentAnswer: entity.answers[1].isCurrentAnswer,
            percent: '${entity.answers[1].percent}%',
          ),
        ],
      );

  setUp(() {
    surveyId = faker.randomGenerator.string(50);
    loadSurveyResult = LoadSurveyResultMock();
    saveSurveyResult = SaveSurveyResultMock();
    answer = faker.lorem.sentence();
    sut = GetXSurveyResultPresenter(
      saveSurveyResult: saveSurveyResult,
      loadSurveyResult: loadSurveyResult,
      surveyId: surveyId,
    );
    mockLoadSurveyResult(mockValidData());
    mockSaveSurveyResult(mockValidData());
  });

  group('Load', () {
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
              surveysId: loadResult.surveyId,
              question: loadResult.question,
              answers: [
                SurveyAnswerViewModel(
                  image: loadResult.answers[0].image,
                  answer: loadResult.answers[0].answer,
                  isCurrentAnswer: loadResult.answers[0].isCurrentAnswer,
                  percent: '${loadResult.answers[0].percent}%',
                ),
                SurveyAnswerViewModel(
                  answer: loadResult.answers[1].answer,
                  isCurrentAnswer: loadResult.answers[1].isCurrentAnswer,
                  percent: '${loadResult.answers[1].percent}%',
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
  });

  group('Save', () {
    test('Should call SaveSurveyResult on save', () async {
      await sut.save(answer: answer);
      verify(saveSurveyResult.save(answer: answer)).called(1);
    });

    test('Should emit correct events on success - onLoad', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(
        expectAsync1((result) => expect(result, mapToViewModel(loadResult))),
      );
      await sut.loadData();
    });

    test('Should emit correct events on success - onLoad and onSave', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.surveyResultStream,
        emitsInAnyOrder([
          mapToViewModel(loadResult),
          mapToViewModel(saveResult),
        ]),
      );

      await sut.loadData();
      await sut.save(answer: answer);
    });

    test('Should emit correct event on failure', () async {
      mockSaveSurveyResultError(DomainError.unexpected);
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(
        null,
        onError: expectAsync1((error) => expect(error, UiError.unexpected.description)),
      );

      await sut.save(answer: answer);
    });

    test('Should emit correct event on acesses denied', () async {
      mockSaveSurveyResultError(DomainError.accessDenied);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.isSessionExpiredStream, emits(true));

      await sut.save(answer: answer);
    });
  });
}
