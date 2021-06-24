import 'package:get/get.dart';

mixin SessionManager on GetxController {
  final _isSessionExpired = RxBool(false);
  Stream<bool> get isSessionExpiredStream => _isSessionExpired.subject.stream;
  set isSessionExpired(bool value) => _isSessionExpired.value = value;
}
