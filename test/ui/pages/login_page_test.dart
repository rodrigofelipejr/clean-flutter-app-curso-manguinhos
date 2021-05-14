import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:fordev/ui/pages/pages.dart';

import 'login_page_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<LoginPresenter>(as: #LoginPresenterMock, returnNullOnMissingStub: false)])
main() {
  late LoginPresenter presenter;
  late StreamController<String> emailErrorController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterMock();
    emailErrorController = StreamController<String>();
    when(presenter.emailErrorStream).thenAnswer((_) => emailErrorController.stream);

    final loginPage = MaterialApp(home: LoginPage(presenter: presenter));
    await tester.pumpWidget(loginPage);
  }

  // ANCHOR roda sempre ao fim dos testes
  tearDown(() {
    emailErrorController.close();
  });

  testWidgets('should load if correct initial state', (WidgetTester tester) async {
    await loadPage(tester);

    final emailTextChildren = find.descendant(of: find.bySemanticsLabel('E-mail'), matching: find.byType(Text));
    expect(
      emailTextChildren,
      findsOneWidget,
      reason:
          'when a TextFieldField has only one text child, means it has no errors, since one of the childs is always the label text',
    );

    final passwordTextChildren = find.descendant(of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
    expect(
      passwordTextChildren,
      findsOneWidget,
      reason:
          'when a TextFieldField has only one text child, means it has no errors, since one of the childs is always the label text',
    );

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.enabled, isFalse);
  });

  testWidgets('should call validates with correct values', (WidgetTester tester) async {
    await loadPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('E-mail'), email);
    verify(presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(presenter.validatePassword(password));
  });

  testWidgets('should presente error if email is invalid', (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add('any error');
    await tester.pump(); // atualizando a tela

    expect(find.text('any error'), findsOneWidget);
  });
}
