import 'package:e_invoice/core/base/api_service.dart';
import 'package:e_invoice/core/routing/app_routes.dart';
import 'package:e_invoice/core/utils/snack_bar_helper.dart';
import 'package:e_invoice/features/home/data/company_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController with SnackBarHelper {
  final RxList<GetCompany> data = <GetCompany>[].obs; // Updated to RxList

  final ApiService apiService = ApiService();
  RxBool isLoading = false.obs;
  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchAndHandleDashboardData(); // Optionally call fetch data on init
  }

  Future<void> fetchAndHandleDashboardData() async {
    isLoading.value = true;
    try {
      final result = await apiService
          .getDocument(); // Assuming this returns List<GetCompany>
      data.value = result; // Set the entire list
      isLoading.value = false;
    } catch (e) {
      showNormalSnackBar('Failed to load data: $e');
      data.clear(); // Clear the list on error
    }
  }

  Future<void> logout() async {
    // Clear all data from SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Navigate to the login screen
    Get.offAllNamed(Routes.login);
  }
}
