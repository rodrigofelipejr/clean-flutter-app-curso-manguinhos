import 'package:flutter/material.dart';

import 'package:fordev/shared/routes/routes.dart';
import 'package:get/get.dart';

Widget makePage({required String path, required Widget Function() page}) {
  final getPage = [
    GetPage(
      name: path,
      page: page,
    ),
    GetPage(
      name: AppRoutes.anyRoute,
      page: () => Scaffold(appBar: AppBar(title: Text('any')), body: Text('fake page')),
    ),
    if (path != AppRoutes.login)
      GetPage(
        name: AppRoutes.login,
        page: () => Scaffold(body: Text('fake login')),
      ),
  ];
  final routerObserver = Get.put<RouteObserver>(RouteObserver<PageRoute>());

  return GetMaterialApp(
    initialRoute: path,
    navigatorObservers: [routerObserver],
    getPages: getPage,
  );
}

String get currentRoute => Get.currentRoute;
