import 'package:e_invoice/features/home/presentation/views/home_view.dart';
import 'package:e_invoice/features/login/presentation/views/login_view.dart';
import 'package:get/get.dart';

import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.main;

  static final routes = [
    GetPage(name: Routes.main, page: () => LoginView()),
    //binding: SplashBinding()),
    //  GetPage(name: Routes.home, page: () => HomeView(), binding: HomeBinding()),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
    ),
    GetPage(
      name: Routes.login,
      page: () => LoginView(),
    ),
  ];
}
