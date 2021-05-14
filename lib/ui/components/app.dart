import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../pages/pages.dart';
import 'package:fordev/ui/constants/constants.dart';

class LoginPresenterMock implements LoginPresenter {
  @override
  void validateEmail(String email) {}

  @override
  void validatePassword(String password) {}

  @override
  Stream<String> get emailErrorStream => throw UnimplementedError();

  @override
  Stream<String?> get passwordErrorStream => throw UnimplementedError();
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '4Dev',
      home: LoginPage(
        presenter: LoginPresenterMock(),
      ),
      theme: ThemeData(
        primaryColor: AppColors.kPrimaryColor,
        primaryColorDark: AppColors.kPrimaryColorDark,
        primaryColorLight: AppColors.kPrimaryColorLight,
        accentColor: AppColors.kPrimaryColor,
        backgroundColor: AppColors.kWhite,
        inputDecorationTheme: AppStyles.kInputDecorationTheme,
        elevatedButtonTheme: AppStyles.kElevatedButtonThemeData,
        textButtonTheme: AppStyles.kTextButtonThemeData,
      ),
    );
  }
}
