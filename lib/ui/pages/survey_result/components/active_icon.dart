import 'package:flutter/material.dart';

import '../../../../ui/constants/constants.dart';

class ActiveIcon extends StatelessWidget {
  const ActiveIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.check_circle,
      color: AppColors.kSecondaryColor,
    );
  }
}
