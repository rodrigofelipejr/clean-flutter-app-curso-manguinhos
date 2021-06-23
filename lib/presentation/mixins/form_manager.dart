import 'package:get/get.dart';

mixin FormManager {
  final _isFormValid = RxBool(false);
  Stream<bool> get isFormValidStream => _isFormValid.subject.stream;
  set isFormValid(bool value) => _isFormValid.value = value;
}
