import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/i18n/i18n.dart';
import '../../../../ui/helpers/errors/ui_error.dart';
import '../login_presenter.dart';
import '../../../constants/constants.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);

    return StreamBuilder<UiError?>(
      stream: presenter.passwordErrorStream,
      builder: (context, snapshot) {
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
            errorText: snapshot.hasData ? snapshot.data!.description : null,
          ),
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          onChanged: presenter.validatePassword,
        );
      },
    );
  }
}
