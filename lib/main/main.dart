import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../../ui/helpers/helpers.dart';

import 'android_app.dart';

void main() {
  //ANCHOR - de quem essa bronca?
  Provider.debugCheckInvalidValueType = null;
  //NOTE - fins didáticos
  //R.load(Locale('en', 'US'));
  runApp(App());
}
