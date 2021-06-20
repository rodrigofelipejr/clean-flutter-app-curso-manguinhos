import 'dart:async';

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

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveyResultPresenterMock();

    final surveysPage = GetMaterialApp(
      initialRoute: '${AppRoutes.surveyResult}/any_survey_id',
      getPages: [
        GetPage(name: '${AppRoutes.surveyResult}/:survey_id', page: () => SurveyResultPage(presenter: presenter)),
      ],
    );

    mockNetworkImagesFor(
      () async => await tester.pumpWidget(surveysPage),
    );
  }

  testWidgets('Should call LoadSurveyResult on page load', (WidgetTester tester) async {
    await loadPage(tester);
    verify(presenter.loadData()).called(1);
  });
}
