import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/route_manager.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/ui/pages/pages.dart';
import 'package:fordev/shared/routes/app_routes.dart';
import 'package:fordev/shared/routes/routes.dart';

import 'surveys_page_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<SurveysPresenter>(as: #SurveysPresenterMock)])
main() {
  late SurveysPresenterMock presenter;

  late StreamController<bool> isLoadingController;

  void initStreams() {
    isLoadingController = StreamController<bool>();
  }

  void mockStreams() {
    when(presenter.isLoadingStream).thenAnswer((_) => isLoadingController.stream);
  }

  void closeStreams() {
    isLoadingController.close();
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
}
