import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:faker/faker.dart';
import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:fordev/ui/pages/pages.dart';

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

    final loginPage = GetMaterialApp(
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginPage(presenter: presenter)),
        GetPage(name: '/any_route', page: () => Scaffold(body: Text('fake page'))),
      ],
    );

    await tester.pumpWidget(loginPage);
  }

  //ANCHOR - Roda sempre ao fim dos testes
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

    expect(find.text('Campo inválido'), findsOneWidget);
  });

  testWidgets('Should presente error if email is empty', (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add(UiError.requiredField);
    await tester.pump(); // atualizando a tela

    expect(find.text('Campo obrigatório'), findsOneWidget);
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

    expect(find.text('Campo obrigatório'), findsOneWidget);
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

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    verify(presenter.auth()).called(1);
  });

  testWidgets('Should present loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should hide loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    isLoadingController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should present error message if authentication fails', (WidgetTester tester) async {
    await loadPage(tester);

    mainErrorController.add(UiError.invalidCredentials);
    await tester.pump();

    expect(find.text('Credenciais inválidas.'), findsOneWidget);
  });

  testWidgets('Should present error message if authentication throws', (WidgetTester tester) async {
    await loadPage(tester);

    mainErrorController.add(UiError.unexpected);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'), findsOneWidget);
  });

  testWidgets('Should change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('/any_route');
    //ANCHOR - como a troca de rota demora um pouco mais  para acontecer é utilizado o pumpAndSettle
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });
}
