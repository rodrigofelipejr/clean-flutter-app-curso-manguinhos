import 'package:flutter/material.dart';
import 'package:fordev/ui/constants/constants.dart';

void showErrorMessage(BuildContext context, String error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: AppColors.kRedLight,
      content: Text(error, textAlign: TextAlign.center),
    ),
  );
}
