import 'package:flutter/material.dart';

import '../../../../ui/helpers/helpers.dart';

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: null,
      child: Text(R.strings.addAccount.toUpperCase()),
    );
  }
}
