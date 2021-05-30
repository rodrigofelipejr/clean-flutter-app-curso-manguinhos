import 'package:flutter/material.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../../constants/constants.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: R.strings.password,
        icon: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Icon(
            Icons.lock,
            color: AppColors.kPrimaryColorLight,
          ),
        ),
      ),
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
    );
  }
}
