import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:faker/faker.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:fordev/ui/pages/pages.dart';

import 'login_page_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<LoginPresenter>(as: #LoginPresenterMock, returnNullOnMissingStub: false)])
main() {
  late LoginPresenter presenter;
  var emailError = RxnString();
  var passwordError = RxnString();
  var mainError = RxnString();
  var isFormValid = RxBool(false);
  var isLoading = RxBool(false);

  void mockStreams() {
    when(presenter.emailError).thenAnswer((_) => emailError);
    when(presenter.passwordError).thenAnswer((_) => passwordError);
    when(presenter.mainError).thenAnswer((_) => mainError);
    when(presenter.isFormValid).thenAnswer((_) => isFormValid);
    when(presenter.isLoading).thenAnswer((_) => isLoading);
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = Get.put<LoginPresenter>(LoginPresenterMock()); //ANCHOR - fazendo o que o PROVIDER fazia (Singleton)

    mockStreams();

    final loginPage = MaterialApp(home: LoginPage(presenter: presenter));
    await tester.pumpWidget(loginPage);
  }

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
    expect(find.byType(CircularProgressIndicator), findsNothing);
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

    emailError.value = 'any error';
    await tester.pump(); // atualizando a tela

    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets('should presente no error if email is valid (null)', (WidgetTester tester) async {
    await loadPage(tester);

    emailError.value = null;
    await tester.pump(); // atualizando a tela

    expect(
      find.descendant(of: find.bySemanticsLabel('E-mail'), matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  testWidgets('should presente no error if email is valid (empty)', (WidgetTester tester) async {
    await loadPage(tester);

    emailError.value = '';
    // ANCHOR - Atualizando a tela
    await tester.pump();

    expect(
      find.descendant(of: find.bySemanticsLabel('E-mail'), matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  testWidgets('should presente error if password is invalid', (WidgetTester tester) async {
    await loadPage(tester);

    passwordError.value = 'any error';
    await tester.pump();

    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets('should presente no error if password is valid (null)', (WidgetTester tester) async {
    await loadPage(tester);

    passwordError.value = null;
    await tester.pump();

    expect(
      find.descendant(of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  testWidgets('should presente no error if password is valid (empty)', (WidgetTester tester) async {
    await loadPage(tester);

    passwordError.value = '';
    await tester.pump();

    expect(
      find.descendant(of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  testWidgets('should enable button if form is valid', (WidgetTester tester) async {
    await loadPage(tester);

    isFormValid.value = true;
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.enabled, isTrue);
  });

  testWidgets('should disable button if form is invalid', (WidgetTester tester) async {
    await loadPage(tester);

    isFormValid.value = false;
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.enabled, isFalse);
  });

  testWidgets('should call authentication on form submit', (WidgetTester tester) async {
    await loadPage(tester);

    isFormValid.value = true;
    await tester.pump();

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    verify(presenter.auth()).called(1);
  });

  testWidgets('should present loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoading.value = true;
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should hide loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoading.value = true;
    await tester.pump();
    isLoading.value = false;
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('should present error message if authentication fails', (WidgetTester tester) async {
    await loadPage(tester);

    mainError.value = 'any error';
    await tester.pump();

    expect(find.text('any error'), findsOneWidget);
  });
}
