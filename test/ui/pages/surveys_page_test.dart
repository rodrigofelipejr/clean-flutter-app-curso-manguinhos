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

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterMock();

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
}
