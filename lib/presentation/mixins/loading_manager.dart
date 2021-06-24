import 'package:get/get.dart';

//NOTE - this is a MIXIN => use WITH
mixin LoadingManager on GetxController {
  final _isLoading = RxBool(false);
  Stream<bool> get isLoadingStream => _isLoading.subject.stream;
  set isLoading(bool value) => _isLoading.value = value;
}
