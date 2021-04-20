import 'package:apnapp/app/ui/pages/_pages.dart';
import 'package:get/get.dart';

import 'package:apnapp/app/modules/home/bindings/home_binding.dart';
import 'package:apnapp/app/modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.HOME;
  static const LOGIN = Routes.LOGIN;


  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginPage(),
    ),
  ];
}
