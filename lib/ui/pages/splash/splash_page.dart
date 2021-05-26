import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

      return Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}
