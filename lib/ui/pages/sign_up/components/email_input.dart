import 'package:flutter/material.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../../constants/constants.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: R.strings.email,
        icon: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Icon(
            Icons.email,
            color: AppColors.kPrimaryColorLight,
          ),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}
