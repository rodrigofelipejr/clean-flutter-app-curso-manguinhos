import 'package:flutter/material.dart';

import '../constants/constants.dart';

class LoginHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      margin: const EdgeInsets.only(bottom: 32.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.kPrimaryColor,
            AppColors.kPrimaryColorDark,
          ],
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            spreadRadius: 0.5,
            blurRadius: 8,
            color: AppColors.kBlack.withOpacity(0.6),
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(100.0),
        ),
      ),
      child: Image(
        image: AssetImage(AppImage.logo),
      ),
    );
  }
}
