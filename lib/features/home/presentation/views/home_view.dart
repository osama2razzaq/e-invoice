import 'package:e_invoice/core/values/app_colors.dart';
import 'package:e_invoice/core/values/app_text_style.dart';
import 'package:e_invoice/features/home/data/company_model.dart';
import 'package:e_invoice/features/home/presentation/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

final HomeController controller = Get.put(HomeController());

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF212632),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: AppColors.yellow,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/profileImage.png'),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  "E-Invoisdigital",
                  style: PromptStyle.appBarLogoStyle,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _showLogoutDialog(context);
              },
              child: const Icon(
                Icons.logout,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        }

        // Hardcoded values if null
        int cleared = controller.data
                .firstWhere((item) => item.type == 'Cleared',
                    orElse: () => GetCompany(type: 'Cleared', total: 0))
                .total ??
            0;
        int rejected = controller.data
                .firstWhere((item) => item.type == 'Rejected',
                    orElse: () => GetCompany(type: 'Rejected', total: 0))
                .total ??
            0;
        int cancelled = controller.data
                .firstWhere((item) => item.type == 'Cancelled',
                    orElse: () => GetCompany(type: 'Cancelled', total: 0))
                .total ??
            0;
        int submitted = controller.data
                .firstWhere((item) => item.type == 'Submitted',
                    orElse: () => GetCompany(type: 'Submitted', total: 0))
                .total ??
            0;
        int invalid = controller.data
                .firstWhere((item) => item.type == 'Invalid',
                    orElse: () => GetCompany(type: 'Invalid', total: 0))
                .total ??
            0;
        int total = controller.data
                .firstWhere((item) => item.type == 'Total',
                    orElse: () => GetCompany(type: 'Total', total: 0))
                .total ??
            0;

        return Padding(
          padding: EdgeInsets.all(8.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 1,
            children: [
              _buildStatusCard('Total', total, Color(0xFF3399FD), Icons.people),
              _buildStatusCard('Cleared', cleared, Color(0xFF189E3E),
                  Icons.person_add_alt_1),
              _buildStatusCard('Rejected', rejected, Color(0xFFF8B111),
                  Icons.shopping_basket),
              _buildStatusCard(
                  'Cancelled', cancelled, Color(0xFF5756D4), Icons.chat_bubble),
              _buildStatusCard(
                  'Submitted', submitted, Color(0xFFE55354), Icons.speed),
              _buildStatusCard(
                  'Invalid', invalid, Color(0xFF212632), Icons.pie_chart),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatusCard(String label, int count, Color color, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color,
        ),
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$count',
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Icon(
                icon,
                size: 30, // Adjust the size as per your requirement
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                controller.logout();
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}
