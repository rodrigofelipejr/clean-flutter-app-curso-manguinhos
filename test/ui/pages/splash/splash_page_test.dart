import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/shared/routes/routes.dart';
import 'package:fordev/ui/pages/pages.dart';

import '../../helpers/helpers.dart';
import 'splash_page_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<SplashPresenter>(as: #SplashPresenterMock),
])
main() {
  late SplashPresenterMock presenter;
  late StreamController<String?> navigateToController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SplashPresenterMock();
    navigateToController = StreamController<String?>();

    when(presenter.navigateToStream).thenAnswer((_) => navigateToController.stream);

    await tester.pumpWidget(makePage(path: AppRoutes.initial, page: () => SplashPage(presenter: presenter)));
  }

  tearDown(() {
    navigateToController.close();
  });

  testWidgets('Should presenter spinner on page load', (WidgetTester tester) async {
    await loadPage(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should call loadCurrentAccount on page load', (WidgetTester tester) async {
    await loadPage(tester);
    verify(presenter.checkAccount()).called(1);
  });

  testWidgets('Should load page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add(AppRoutes.anyRoute);
    await tester.pumpAndSettle();

    expect(currentRoute, AppRoutes.anyRoute);
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('Should not change page - Splash', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('');
    await tester.pump();
    expect(currentRoute, AppRoutes.initial);

    navigateToController.add(null);
    await tester.pump();
    expect(currentRoute, AppRoutes.initial);
  });
}
