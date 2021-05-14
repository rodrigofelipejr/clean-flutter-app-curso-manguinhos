import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login_presenter.dart';
import '../../../constants/constants.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);

    return StreamBuilder<String?>(
      stream: presenter.passwordErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: 'Senha',
            icon: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Icon(
                Icons.lock,
                color: AppColors.kPrimaryColorLight,
              ),
            ),
            errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
          ),
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          onChanged: presenter.validatePassword,
        );
      },
    );
  }
}
