import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../factories.dart';
import '../../../../ui/pages/pages.dart';

Widget makeLoginPage() {
  final presenter = Get.put<LoginPresenter>(makeGetxLoginPresenter());
  return LoginPage(presenter: presenter);
}
