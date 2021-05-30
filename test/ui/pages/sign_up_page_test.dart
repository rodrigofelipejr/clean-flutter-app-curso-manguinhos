import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:fordev/ui/pages/pages.dart';

main() {
  Future<void> loadPage(WidgetTester tester) async {
    final signUpPage = GetMaterialApp(
      initialRoute: '/sign-up',
      getPages: [
        GetPage(name: '/sign-up', page: () => SignUpPage()),
      ],
    );

    await tester.pumpWidget(signUpPage);
  }

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
}
