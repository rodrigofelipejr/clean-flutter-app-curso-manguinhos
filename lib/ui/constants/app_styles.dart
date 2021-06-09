import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  static final kHeadline1 = GoogleFonts.notoSans(
    color: AppColors.kPrimaryColorDark,
    fontSize: 30.0,
    fontWeight: FontWeight.w700,
  );

  static final kButton = GoogleFonts.notoSans(
    color: AppColors.kPrimaryColor,
    fontWeight: FontWeight.w600,
  );

  static final kButtonWhite = GoogleFonts.notoSans(
    color: AppColors.kWhite,
    fontWeight: FontWeight.w600,
  );

  static final kButtonGray = GoogleFonts.notoSans(
    color: AppColors.kGreyDark,
    fontWeight: FontWeight.w600,
  );

  static final kSurveysDate = GoogleFonts.notoSans(
    color: AppColors.kWhite,
    fontWeight: FontWeight.w600,
    fontSize: 20.0,
  );

  static final kSurveysDescription = GoogleFonts.notoSans(
    color: AppColors.kWhite,
    fontWeight: FontWeight.w400,
    fontSize: 24.0,
  );
}

class AppStyles {
  static final kInputDecorationTheme = InputDecorationTheme(
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.kPrimaryColorLight),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.kPrimaryColor),
    ),
    alignLabelWithHint: true,
  );

  static final kElevatedButtonThemeData = ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        const Set<MaterialState> interactiveStates = <MaterialState>{
          MaterialState.disabled,
        };
        if (states.any(interactiveStates.contains)) return AppColors.kGrey;
        return AppColors.kPrimaryColor;
      }),
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        const Set<MaterialState> interactiveStates = <MaterialState>{
          MaterialState.disabled,
        };
        if (states.any(interactiveStates.contains)) return AppColors.kGreyDark;
        return AppColors.kWhite;
      }),
      overlayColor: MaterialStateProperty.all(AppColors.kPrimaryColorLight),
      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0)),
      textStyle: MaterialStateProperty.all(AppTextStyles.kButtonGray),
      // MaterialStateProperty.resolveWith((states) {
      //   const Set<MaterialState> interactiveStates = <MaterialState>{
      //     MaterialState.disabled,
      //   };
      //   if (states.any(interactiveStates.contains)) return AppTextStyles.kButtonGray;
      //   return AppTextStyles.kButtonWhite;
      // }),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(58.0))),
    ),
  );

  static final kTextButtonThemeData = TextButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStateProperty.all(AppTextStyles.kButton),
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        const Set<MaterialState> interactiveStates = <MaterialState>{
          MaterialState.pressed,
          MaterialState.hovered,
          MaterialState.focused,
        };
        if (states.any(interactiveStates.contains)) return AppColors.kWhite;
        return AppColors.kPrimaryColor;
      }),
      overlayColor: MaterialStateProperty.all(AppColors.kPrimaryColorLight),
      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0)),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(58.0))),
    ),
  );
}
