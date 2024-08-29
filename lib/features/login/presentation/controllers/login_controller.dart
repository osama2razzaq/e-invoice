import 'dart:convert';
import 'package:e_invoice/core/base/api_service.dart';
import 'package:e_invoice/core/routing/app_routes.dart';
import 'package:e_invoice/core/utils/snack_bar_helper.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController with SnackBarHelper {
  // Observables for email and password
  var email = ''.obs;
  var password = ''.obs;

  // TextEditingController for the input fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  RxBool isPasswordVisible = false.obs;
  // Instance of ApiService
  final ApiService apiService =
      ApiService(); // Replace with your actual base URL

  // Device token (for demonstration purposes, this should be retrieved from your device)
  String? fcmtoken = '';

  // Method to handle login

  @override
  void onInit() async {
    super.onInit();
  }

  void login() async {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        final response = await apiService.login(
            emailController.text, passwordController.text);

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          final accessToken = responseData['token'];
          final userType = responseData['userType'];
          final companyCode = responseData['companyCode'];

          final prefs = await SharedPreferences.getInstance();

          await prefs.setString('access_token', accessToken);
          await prefs.setString('userType', userType);
          await prefs.setString('companyCode', companyCode);

          Get.offAllNamed(Routes.home);
          showNormalSnackBar("Login successful");
        } else {
          // Parse error response
          final responseData = jsonDecode(response.body);

          if (responseData['errors'] != null) {
            // Handle validation errors
            final validationErrors = responseData['errors'];
            final errorMessage = validationErrors.isNotEmpty
                ? validationErrors.values.first.join(', ')
                : 'Unknown error';
            showErrorSnackBar("Error: $errorMessage");
          } else {
            // Handle general error
            final errorMessage = responseData['message'] ?? 'Unknown error';
            showErrorSnackBar("Error: $errorMessage");
          }

          // Save error message and status code locally
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('error_status_code', response.statusCode);
          await prefs.setString(
              'error_message', responseData['message'] ?? 'Unknown error');
        }
      } catch (e) {
        // Handle any errors that occur during the API call
        showErrorSnackBar("An error occurred: $e");

        // Save error message and status code locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(
            'error_status_code', -1); // -1 indicates an exception
        await prefs.setString('error_message', e.toString());
      }
    } else {
      showErrorSnackBar("Email or password cannot be empty");
    }
  }
}
