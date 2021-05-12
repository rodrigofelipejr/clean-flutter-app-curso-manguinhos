import 'package:flutter/material.dart';

import '../pages/pages.dart';
import 'package:fordev/ui/constants/constants.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '4Dev',
      home: LoginPage(),
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
