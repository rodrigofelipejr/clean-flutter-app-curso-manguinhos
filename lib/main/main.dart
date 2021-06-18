//NOTE - Aqui temos o composition root, onde fazemos a composição dos objetos

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../../ui/helpers/helpers.dart';

import 'android_app.dart';

void main() {
  //FIXME - de quem essa bronca?
  Provider.debugCheckInvalidValueType = null;
  //NOTE - fins didáticos
  //R.load(Locale('en', 'US'));
  runApp(App());
}
