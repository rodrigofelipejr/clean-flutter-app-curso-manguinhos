import 'package:flutter/material.dart';

import '../constants/constants.dart';

void showErrorMessage(BuildContext context, String error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: AppColors.kRedLight,
      content: Text(error, textAlign: TextAlign.center),
    ),
  );
}
