import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:fordev/shared/routes/routes.dart';
import 'package:fordev/ui/pages/pages.dart';

import 'survey_result_page_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<SurveyResultPresenter>(as: #SurveyResultPresenterMock),
])
main() {
  late SurveyResultPresenterMock presenter;

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
    presenter = SurveyResultPresenterMock();

    initStreams();
    mockStreams();

    final surveysPage = GetMaterialApp(
      initialRoute: '${AppRoutes.surveyResult}/any_survey_id',
      getPages: [
        GetPage(name: '${AppRoutes.surveyResult}/:survey_id', page: () => SurveyResultPage(presenter: presenter)),
      ],
    );

    await mockNetworkImagesFor(
      () async => await tester.pumpWidget(surveysPage),
    );
  }

  testWidgets('Should call LoadSurveyResult on page load', (WidgetTester tester) async {
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
