import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/pages/sign_up/sign_up.dart';
import '../../../../ui/helpers/helpers.dart';
import '../../../constants/constants.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<UiError?>(
        stream: presenter.emailErrorStream,
        builder: (context, snapshot) {
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
              errorText: snapshot.hasData ? snapshot.data!.description : null,
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: presenter.validateEmail,
          );
        });
  }
}
