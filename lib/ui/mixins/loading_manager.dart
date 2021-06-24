import 'package:flutter/material.dart';

import '../../ui/components/components.dart';

mixin LoadingManager {
  void handleLoading(BuildContext context, Stream<bool> stream) {
    stream.listen((isLoading) async {
      await Future.delayed(Duration(milliseconds: 500));
      if (isLoading) {
        showLoading(context);
      } else {
        hideLoading(context);
      }
    });
  }
}
