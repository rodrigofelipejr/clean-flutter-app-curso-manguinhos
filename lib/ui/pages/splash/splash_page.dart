import 'package:flutter/material.dart';

import '../../../ui/mixins/mixins.dart';
import '../../../ui/constants/constants.dart';
import 'splash.dart';

class SplashPage extends StatefulWidget {
  final SplashPresenter presenter;

  const SplashPage({Key? key, required this.presenter}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with NavigationManager {
  @override
  void didChangeDependencies() {
    widget.presenter.checkAccount();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        handleNavigation(widget.presenter.navigateToStream, clear: true);

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
      },
    );
  }
}
