import 'package:flutter/material.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../../constants/constants.dart';

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: R.strings.name,
        icon: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Icon(
            Icons.person,
            color: AppColors.kPrimaryColorLight,
          ),
        ),
      ),
      keyboardType: TextInputType.name,
    );
  }
}
