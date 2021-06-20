import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/route_manager.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:fordev/shared/routes/app_routes.dart';
import 'package:fordev/shared/routes/routes.dart';

import 'surveys_page_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<SurveysPresenter>(as: #SurveysPresenterMock)])
main() {
  late SurveysPresenterMock presenter;

  late StreamController<bool> isLoadingController;
  late StreamController<List<SurveyViewModel>> surveysController;

  void initStreams() {
    isLoadingController = StreamController<bool>();
    surveysController = StreamController<List<SurveyViewModel>>();
  }

  void mockStreams() {
    when(presenter.isLoadingStream).thenAnswer((_) => isLoadingController.stream);
    when(presenter.surveysStream).thenAnswer((_) => surveysController.stream);
  }

  void closeStreams() {
    isLoadingController.close();
    surveysController.close();
  }

  tearDown(() {
    closeStreams();
  });

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterMock();

    initStreams();
    mockStreams();

    final surveysPage = GetMaterialApp(
      initialRoute: AppRoutes.surveys,
      getPages: [GetPage(name: AppRoutes.surveys, page: () => SurveysPage(presenter))],
    );

    await tester.pumpWidget(surveysPage);
  }

  List<SurveyViewModel> makeSurveys() => [
        SurveyViewModel(id: '1', question: 'Question 1', date: 'Date 1', didAnswer: true),
        SurveyViewModel(id: '2', question: 'Question 2', date: 'Date 2', didAnswer: false),
      ];

  testWidgets('Should call LoadSurveys on page load', (WidgetTester tester) async {
    await loadPage(tester);
    verify(presenter.loadData()).called(1);
  });

  testWidgets('Should handle loading correctly', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should present error if surveysController fails', (WidgetTester tester) async {
    await loadPage(tester);

    surveysController.addError(UiError.unexpected.description);
    await tester.pump();

    expect(find.text(R.strings.msgUnexpectedError), findsOneWidget);
    expect(find.text(R.strings.reload), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);
  });

  testWidgets('Should present list surveysController success', (WidgetTester tester) async {
    await loadPage(tester);

    surveysController.add(makeSurveys());
    await tester.pump();

    expect(find.text(R.strings.msgUnexpectedError), findsNothing);
    expect(find.text(R.strings.reload), findsNothing);

    expect(find.text('Question 1'), findsWidgets);
    expect(find.text('Question 2'), findsWidgets);

    expect(find.text('Date 1'), findsWidgets);
    expect(find.text('Date 2'), findsWidgets);
  });

  testWidgets('Should call LoadSurveys on reload button click', (WidgetTester tester) async {
    await loadPage(tester);

    surveysController.addError(UiError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text(R.strings.reload));

    verify(presenter.loadData()).called(2);
  });
}
