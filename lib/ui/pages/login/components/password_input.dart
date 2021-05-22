import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../login_presenter.dart';
import '../../../constants/constants.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<LoginPresenter>();

    return Obx(() => TextFormField(
          decoration: InputDecoration(
            labelText: 'Senha',
            icon: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Icon(
                Icons.lock,
                color: AppColors.kPrimaryColorLight,
              ),
            ),
            errorText: presenter.passwordError.value?.isEmpty == true ? null : presenter.passwordError.value,
          ),
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          onChanged: presenter.validatePassword,
        ));
  }
}
