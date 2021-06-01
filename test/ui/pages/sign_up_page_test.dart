import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/ui/helpers/helpers.dart';
import 'package:get/get.dart';

import 'package:fordev/ui/pages/pages.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sign_up_page_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<SignUpPresenter>(as: #SignUpPresenterMock)])
main() {
  late SignUpPresenter presenter;
  late StreamController<UiError?> nameErrorController;
  late StreamController<UiError?> emailErrorController;
  late StreamController<UiError?> passwordErrorController;
  late StreamController<UiError?> passwordConfirmationErrorController;

  void initStreams() {
    nameErrorController = StreamController<UiError?>();
    emailErrorController = StreamController<UiError?>();
    passwordErrorController = StreamController<UiError?>();
    passwordConfirmationErrorController = StreamController<UiError?>();
  }

  void mockStreams() {
    when(presenter.nameErrorStream).thenAnswer((_) => nameErrorController.stream);
    when(presenter.emailErrorStream).thenAnswer((_) => emailErrorController.stream);
    when(presenter.passwordErrorStream).thenAnswer((_) => passwordErrorController.stream);
    when(presenter.passwordConfirmationErrorStream).thenAnswer((_) => passwordConfirmationErrorController.stream);
  }

  void closeStreams() {
    nameErrorController.close();
    emailErrorController.close();
    passwordErrorController.close();
    passwordConfirmationErrorController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SignUpPresenterMock();

    initStreams();
    mockStreams();

    final signUpPage = GetMaterialApp(
      initialRoute: '/sign-up',
      getPages: [
        GetPage(name: '/sign-up', page: () => SignUpPage(presenter: presenter)),
      ],
    );

    await tester.pumpWidget(signUpPage);
  }

  //ANCHOR - Roda sempre ao fim dos testes
  tearDown(() {
    closeStreams();
  });

  testWidgets('Should load if correct initial state', (WidgetTester tester) async {
    await loadPage(tester);

    final nameTextChildren = find.descendant(of: find.bySemanticsLabel('Nome'), matching: find.byType(Text));
    expect(nameTextChildren, findsOneWidget);

    final emailTextChildren = find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
    expect(emailTextChildren, findsOneWidget);

    final passwordTextChildren = find.descendant(of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
    expect(passwordTextChildren, findsOneWidget);

    final passwordConfirmationTextChildren =
        find.descendant(of: find.bySemanticsLabel('Confirmar senha'), matching: find.byType(Text));
    expect(passwordConfirmationTextChildren, findsOneWidget);

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.enabled, isFalse);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should call validates with correct values', (WidgetTester tester) async {
    await loadPage(tester);

    final name = faker.person.name();
    await tester.enterText(find.bySemanticsLabel('Nome'), name);
    verify(presenter.validateName(name));

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(presenter.validatePassword(password));

    await tester.enterText(find.bySemanticsLabel('Confirmar senha'), password);
    verify(presenter.validatePasswordConfirmation(password));
  });

  testWidgets('Should presente email error', (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add(UiError.invalidField);
    await tester.pump();
    expect(find.text('Campo inválido'), findsOneWidget);

    emailErrorController.add(UiError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatório'), findsOneWidget);

    emailErrorController.add(null);
    await tester.pump();
    expect(find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text)), findsOneWidget);
  });
}
