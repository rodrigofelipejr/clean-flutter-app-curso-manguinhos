import 'package:flutter/material.dart';
import 'package:fordev/utils/i18n/i18n.dart';
import 'package:provider/provider.dart';

import 'android_app.dart';

void main() {
  Provider.debugCheckInvalidValueType = null; //ANCHOR - de quem essa bronca?
  R.load(Locale('en', 'US'));
  runApp(App());
}
