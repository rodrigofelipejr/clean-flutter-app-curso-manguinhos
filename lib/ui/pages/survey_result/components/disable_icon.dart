import 'package:flutter/material.dart';

import '../../../../ui/constants/constants.dart';

class DisableIcon extends StatelessWidget {
  const DisableIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.check_circle,
      color: AppColors.kDisableColor,
    );
  }
}
