import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:fordev/ui/pages/survey_result/components/components.dart';
import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:fordev/shared/routes/routes.dart';
import 'package:fordev/ui/pages/pages.dart';

import 'survey_result_page_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<SurveyResultPresenter>(as: #SurveyResultPresenterMock, returnNullOnMissingStub: true),
])
main() {
  late SurveyResultPresenterMock presenter;
  late String urlImage;

  late StreamController<bool> isLoadingController;
  late StreamController<bool> isSessionExpiredController;
  late StreamController<SurveyResultViewModel> surveyResultController;

  void initStreams() {
    isLoadingController = StreamController<bool>();
    isSessionExpiredController = StreamController<bool>();
    surveyResultController = StreamController<SurveyResultViewModel>();
  }

  void mockStreams() {
    when(presenter.isLoadingStream).thenAnswer((_) => isLoadingController.stream);
    when(presenter.isSessionExpiredStream).thenAnswer((_) => isSessionExpiredController.stream);
    when(presenter.surveyResultStream).thenAnswer((_) => surveyResultController.stream);
  }

  void closeStreams() {
    isLoadingController.close();
    isSessionExpiredController.close();
    surveyResultController.close();
  }

  SurveyResultViewModel makeSurveyResult() => SurveyResultViewModel(
        surveysId: faker.guid.guid(),
        question: 'Question 1',
        answers: [
          SurveyAnswerViewModel(
            image: urlImage,
            answer: 'Answer 0',
            isCurrentAnswer: true,
            percent: '60%',
          ),
          SurveyAnswerViewModel(
            answer: 'Answer 1',
            isCurrentAnswer: false,
            percent: '40%',
          ),
        ],
      );

  tearDown(() {
    closeStreams();
  });

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveyResultPresenterMock();

    initStreams();
    mockStreams();

    final surveysPage = GetMaterialApp(
      initialRoute: '${AppRoutes.surveyResult}/any_survey_id',
      getPages: [
        GetPage(name: '${AppRoutes.surveyResult}/:survey_id', page: () => SurveyResultPage(presenter)),
        GetPage(name: AppRoutes.login, page: () => Scaffold(body: Text('fake login'))),
      ],
    );

    await mockNetworkImagesFor(
      () async => await tester.pumpWidget(surveysPage),
    );
  }

  setUpAll(() {
    urlImage = 'https://angular.io/assets/images/logos/angular/angular.png';
  });

  testWidgets('Should call LoadSurveyResult on page load', (WidgetTester tester) async {
    await loadPage(tester);
    verify(presenter.loadData()).called(1);
  });

  testWidgets('Should handle loading correctly', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump(Duration(milliseconds: 500));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(false);
    await tester.pump(Duration(milliseconds: 500));
    expect(find.byType(CircularProgressIndicator), findsNothing);

    isLoadingController.add(true);
    await tester.pump(Duration(milliseconds: 500));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should present error if surveyResultStream fails', (WidgetTester tester) async {
    await loadPage(tester);

    surveyResultController.addError(UiError.unexpected.description);
    await tester.pump();

    expect(find.text(R.strings.msgUnexpectedError), findsOneWidget);
    expect(find.text(R.strings.reload), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);
  });

  testWidgets('Should call LoadResultSurvey on reload button click', (WidgetTester tester) async {
    await loadPage(tester);

    surveyResultController.addError(UiError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text(R.strings.reload));

    verify(presenter.loadData()).called(2);
  });

  testWidgets('Should present valid data if surveyResultStream success', (WidgetTester tester) async {
    await loadPage(tester);

    surveyResultController.add(makeSurveyResult());

    await mockNetworkImagesFor(
      () async => await tester.pump(),
    );

    expect(find.text(R.strings.msgUnexpectedError), findsNothing);
    expect(find.text(R.strings.reload), findsNothing);
    expect(find.text('Question 1'), findsOneWidget);
    expect(find.text('Answer 0'), findsOneWidget);
    expect(find.text('60%'), findsOneWidget);
    expect(find.text('Answer 1'), findsOneWidget);
    expect(find.text('40%'), findsOneWidget);
    expect(find.byType(ActiveIcon), findsOneWidget);
    expect(find.byType(DisableIcon), findsOneWidget);

    final image = tester.widget<Image>(find.byType(Image)).image as NetworkImage;
    expect(image.url, urlImage);
  });

  testWidgets('Should logout', (WidgetTester tester) async {
    await loadPage(tester);

    isSessionExpiredController.add(true);
    await tester.pumpAndSettle();

    expect(Get.currentRoute, AppRoutes.login);
    expect(find.text('fake login'), findsOneWidget);
  });

  testWidgets('Should not logout', (WidgetTester tester) async {
    await loadPage(tester);

    isSessionExpiredController.add(false);
    await tester.pumpAndSettle();
    expect(Get.currentRoute, '${AppRoutes.surveyResult}/any_survey_id');
  });

  testWidgets('Should call save on list item click', (WidgetTester tester) async {
    await loadPage(tester);

    surveyResultController.add(makeSurveyResult());
    await mockNetworkImagesFor(
      () async => await tester.pump(),
    );

    await tester.tap(find.text('Answer 1'));
    verify(presenter.save(answer: 'Answer 1')).called(1);
  });
}
