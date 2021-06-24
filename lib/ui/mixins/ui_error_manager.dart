import 'package:flutter/material.dart';

import '../../ui/components/components.dart';
import '../../ui/helpers/helpers.dart';

mixin UIErrorManager {
  void handleMainError(BuildContext context, Stream<UiError?> stream) {
    stream.listen((error) {
      if (error != null) {
        showErrorMessage(context, error.description);
      }
    });
  }
}
