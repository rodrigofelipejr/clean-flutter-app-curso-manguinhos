import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ui/helpers/helpers.dart';

import 'android_app.dart';

void main() {
  Provider.debugCheckInvalidValueType = null; //ANCHOR - de quem essa bronca?
  R.load(Locale('en', 'US'));
  runApp(App());
}
