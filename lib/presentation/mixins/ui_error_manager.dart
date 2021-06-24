import 'package:get/get.dart';

import '../../ui/helpers/helpers.dart';

mixin UIErrorManager on GetxController {
  final _mainError = Rxn<UiError>();
  Stream<UiError?> get mainErrorStream => _mainError.stream;
  set mainError(UiError? value) => _mainError.value = value;
}
