import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/pages/sign_up/sign_up.dart';
import '../../../../ui/helpers/helpers.dart';
import '../../../constants/constants.dart';

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<UiError?>(
      stream: presenter.nameErrorStream,
      builder: (context, snapshot) {
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
            errorText: snapshot.hasData ? snapshot.data!.description : null,
          ),
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          onChanged: presenter.validateName,
        );
      },
    );
  }
}
