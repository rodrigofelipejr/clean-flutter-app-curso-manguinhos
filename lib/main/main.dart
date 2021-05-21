import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'android_app.dart';

void main() {
  Provider.debugCheckInvalidValueType = null; //ANCHOR - de quem essa bronca?
  runApp(App());
}
