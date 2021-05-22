import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../login_presenter.dart';
import '../../../constants/constants.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<LoginPresenter>();

    return Obx(() => TextFormField(
          decoration: InputDecoration(
            labelText: 'E-mail',
            icon: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Icon(
                Icons.email,
                color: AppColors.kPrimaryColorLight,
              ),
            ),
            errorText: presenter.emailError.value?.isEmpty == true ? null : presenter.emailError.value,
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: presenter.validateEmail,
        ));
  }
}
