import 'package:flutter/material.dart';
import 'package:fordev/ui/constants/constants.dart';

ThemeData appTheme() {
  return ThemeData(
    primaryColor: AppColors.kPrimaryColor,
    primaryColorDark: AppColors.kPrimaryColorDark,
    primaryColorLight: AppColors.kPrimaryColorLight,
    accentColor: AppColors.kPrimaryColor,
    backgroundColor: AppColors.kWhite,
    inputDecorationTheme: AppStyles.kInputDecorationTheme,
    elevatedButtonTheme: AppStyles.kElevatedButtonThemeData,
    textButtonTheme: AppStyles.kTextButtonThemeData,
  );
}
