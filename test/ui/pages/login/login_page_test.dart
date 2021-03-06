import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:fordev/shared/routes/routes.dart';
import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/pages.dart';

import '../../helpers/helpers.dart';
import 'login_page_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<LoginPresenter>(as: #LoginPresenterMock)])
main() {
  late LoginPresenter presenter;
  late StreamController<UiError?> emailErrorController;
  late StreamController<UiError?> passwordErrorController;
  late StreamController<UiError?> mainErrorController;
  late StreamController<String?> navigateToController;
  late StreamController<bool> isFormValidController;
  late StreamController<bool> isLoadingController;

  void initStreams() {
    emailErrorController = StreamController<UiError?>();
    passwordErrorController = StreamController<UiError?>();
    mainErrorController = StreamController<UiError?>();
    navigateToController = StreamController<String?>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
  }

  void mockStreams() {
    when(presenter.emailErrorStream).thenAnswer((_) => emailErrorController.stream);
    when(presenter.passwordErrorStream).thenAnswer((_) => passwordErrorController.stream);
    when(presenter.mainErrorStream).thenAnswer((_) => mainErrorController.stream);
    when(presenter.navigateToStream).thenAnswer((_) => navigateToController.stream);
    when(presenter.isFormValidStream).thenAnswer((_) => isFormValidController.stream);
    when(presenter.isLoadingStream).thenAnswer((_) => isLoadingController.stream);
  }

  void closeStreams() {
    emailErrorController.close();
    passwordErrorController.close();
    mainErrorController.close();
    navigateToController.close();
    isFormValidController.close();
    isLoadingController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterMock();

    initStreams();
    mockStreams();

    await tester.pumpWidget(makePage(path: AppRoutes.login, page: () => LoginPage(presenter: presenter)));
  }

  //NOTE - Roda sempre ao fim dos testes
  tearDown(() {
    closeStreams();
  });

  testWidgets('Should load if correct initial state', (WidgetTester tester) async {
    await loadPage(tester);

    final emailTextChildren = find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
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

  testWidgets('Should call validates with correct values', (WidgetTester tester) async {
    await loadPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(presenter.validatePassword(password));
  });

  testWidgets('Should presente error if email is invalid', (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add(UiError.invalidField);
    await tester.pump(); // atualizando a tela

    expect(find.text('Campo inv??lido'), findsOneWidget);
  });

  testWidgets('Should presente error if email is empty', (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add(UiError.requiredField);
    await tester.pump(); // atualizando a tela

    expect(find.text('Campo obrigat??rio'), findsOneWidget);
  });

  testWidgets('Should presente no error if email is valid (null)', (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add(null);
    await tester.pump(); // atualizando a tela

    expect(find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text)), findsOneWidget);
  });

  testWidgets('Should presente error if password is empty', (WidgetTester tester) async {
    await loadPage(tester);

    passwordErrorController.add(UiError.requiredField);
    await tester.pump();

    expect(find.text('Campo obrigat??rio'), findsOneWidget);
  });

  testWidgets('Should presente no error if password is valid (null)', (WidgetTester tester) async {
    await loadPage(tester);

    passwordErrorController.add(null);
    await tester.pump();

    expect(
      find.descendant(of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  testWidgets('Should enable button if form is valid', (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.enabled, isTrue);
  });

  testWidgets('Should disable button if form is invalid', (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(false);
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.enabled, isFalse);
  });

  testWidgets('Should call authentication on form submit', (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();
    final button = find.byType(ElevatedButton);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(presenter.auth()).called(1);
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

  testWidgets('Should present error message if authentication fails', (WidgetTester tester) async {
    await loadPage(tester);

    mainErrorController.add(UiError.invalidCredentials);
    await tester.pump();

    expect(find.text('Credenciais inv??lidas.'), findsOneWidget);
  });

  testWidgets('Should present error message if authentication throws', (WidgetTester tester) async {
    await loadPage(tester);

    mainErrorController.add(UiError.unexpected);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'), findsOneWidget);
  });

  testWidgets('Should change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add(AppRoutes.anyRoute);
    //NOTE - como a troca de rota demora um pouco mais  para acontecer ?? utilizado o pumpAndSettle
    await tester.pumpAndSettle();

    expect(currentRoute, AppRoutes.anyRoute);
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('Should call gotoSignUp on link click', (WidgetTester tester) async {
    await loadPage(tester);

    final button = find.text('Criar conta');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(presenter.goToSignUp()).called(1);
  });

  testWidgets('Should call goToSignUp on link click', (WidgetTester tester) async {
    await loadPage(tester);

    final button = find.text('Criar conta');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(presenter.goToSignUp()).called(1);
  });
}
