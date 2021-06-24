import 'package:get/get.dart';

import '../../shared/routes/routes.dart';

mixin SessionManager {
  void handleSessionExpired(Stream<bool> stream) {
    stream.listen((isExpired) async {
      if (isExpired == true) {
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }
}
