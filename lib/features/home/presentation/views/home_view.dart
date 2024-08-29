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
        backgroundColor: AppColors.black.withOpacity(0.8),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Profile Image
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: AppColors.yellow, // Background color
                borderRadius: BorderRadius.circular(30), // Rounded corners
              ),
              child: const CircleAvatar(
                radius: 20, // Adjust size as needed
                backgroundImage: AssetImage(
                    'assets/images/profileImage.png'), // Replace with your image asset
              ),
            ),
            // Center title
            Expanded(
              child: Center(
                child: Text(
                  "E-Invoisdigital",
                  style: PromptStyle.appBarLogoStyle,
                ),
              ),
            ),
            // Logout Button
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

        // Filter only GroupTotals
        List<GetCompany> groupTotalsItems = controller.data
            .where((item) => item.tblName == 'GroupTotals')
            .toList();

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: 1, // Only 1 group (GroupTotals)
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'GroupTotals',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 2,
                  ),
                  itemCount: groupTotalsItems.length,
                  itemBuilder: (context, itemIndex) {
                    final item = groupTotalsItems[itemIndex];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            colors: _getGradientColors(item.type.toString()),
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.type.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Total: ${item.total}',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      }),
    );
  }

  List<Color> _getGradientColors(String tblName) {
    Map<String, List<Color>> gradients = {
      'Invalid': [Colors.blue, Colors.blueAccent],
      'Submitted': [Colors.orange, Colors.deepOrangeAccent],
      // 'DocumentStatus': [Colors.pink, Colors.redAccent],
      // 'DocumentTypes': [Colors.green, Colors.lightGreen],
    };

    // Return default gradient if tblName is not found
    return gradients[tblName] ?? [Colors.grey, Colors.black54];
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
