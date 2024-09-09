import 'dart:io';
import 'package:e_invoice/core/routing/app_pages.dart';
import 'package:e_invoice/core/routing/app_routes.dart';
import 'package:e_invoice/core/values/app_colors.dart';
import 'package:e_invoice/features/login/presentation/controllers/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request notification permissions on iOS (optional for Android)

  // Initialize the AuthService
  final authService = AuthService();
  final token = await authService.getAccessToken();

  // Determine the initial route based on the token

  final initialRoute = (token != null) ? Routes.home : Routes.login;

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(0xFF212632) // Set your desired color here
        ));

    return GetMaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      locale: Get.deviceLocale,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      // translations: Apptranslations(),
      // fallbackLocale: Apptranslations.fallbackLocale,
      // theme: AppTheme.mainTheme,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}
