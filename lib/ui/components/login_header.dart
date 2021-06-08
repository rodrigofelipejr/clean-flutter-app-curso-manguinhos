import 'package:flutter/material.dart';

import '../constants/constants.dart';

enum SizeType { small, medium, large }

class LoginHeader extends StatelessWidget {
  final config = {
    SizeType.small: {
      "height": 0.30,
      "maxHeight": 280.0,
    },
    SizeType.medium: {
      "height": 0.40,
      "maxHeight": 340.0,
    },
  };

  Widget _buildLogo() {
    return Image(
      image: AssetImage(AppImage.logo),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    if (screen.height <= 640.0) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 220.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.35,
          decoration: _buildBoxDecoration(),
          child: _buildLogo(),
        ),
      );
    } else {
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 340.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.40,
          decoration: _buildBoxDecoration(),
          child: _buildLogo(),
        ),
      );
    }
  }
}
