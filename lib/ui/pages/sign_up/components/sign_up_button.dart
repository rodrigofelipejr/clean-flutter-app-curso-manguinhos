import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/pages/sign_up/sign_up.dart';
import '../../../../ui/helpers/helpers.dart';

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<bool>(
        stream: presenter.isFormValidStream,
        builder: (context, snapshot) {
          return ElevatedButton(
            onPressed: snapshot.data == true ? presenter.signUp : null,
            child: Text(R.strings.addAccount.toUpperCase()),
          );
        });
  }
}
