import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../ui/constants/constants.dart';
import 'splash.dart';

class SplashPage extends StatelessWidget {
  final SplashPresenter presenter;

  const SplashPage({Key? key, required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    presenter.checkAccount();
    return Builder(builder: (context) {
      presenter.navigateToStream.listen((page) {
        if (page?.isNotEmpty == true) {
          Get.offAllNamed(page!);
        }
      });

      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              AppColors.kPrimaryColor,
              AppColors.kPrimaryColorDark,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage(AppImage.logo), width: 100.0, height: 100.0),
            SizedBox(height: 20.0),
            CircularProgressIndicator(
              backgroundColor: AppColors.kPrimaryColor,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.kWhite),
            ),
          ],
        ),
      );
    });
  }
}
