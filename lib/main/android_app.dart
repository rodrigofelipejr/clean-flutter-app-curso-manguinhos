import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:get/get.dart';

import '../shared/routes/routes.dart';
import '../ui/components/components.dart';
import 'factories/factories.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: '4Dev',
      theme: appTheme(),
      initialRoute: AppRoutes.initial,
      getPages: [
        GetPage(name: AppRoutes.initial, page: makeSplashPage, transition: Transition.fade),
        GetPage(name: AppRoutes.login, page: makeLoginPage, transition: Transition.fadeIn),
        GetPage(name: AppRoutes.singUp, page: makeSignUpPage),
        //ANCHOR - remove
        GetPage(name: AppRoutes.surveys, page: () => Scaffold(body: Text('Enquetes')), transition: Transition.fadeIn),
      ],
    );
  }
}
