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
    // Grouping the data by tblName
    Map<String, List<GetCompany>> groupedData = {};
    for (var item in controller.data) {
      if (groupedData.containsKey(item.tblName)) {
        groupedData[item.tblName]!.add(item);
      } else {
        groupedData[item.tblName.toString()] = [item];
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black.withOpacity(0.8),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Profile Image
            Container(
              padding: EdgeInsets.all(3),
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
                // Handle logout action
                _showLogoutDialog(context);
              },
              child: const Icon(
                Icons.logout, // Use the appropriate logout icon
                color: Colors.white,
                size: 24, // Adjust size as needed
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          // Show loading indicator
          return const Center(
              child: const CircularProgressIndicator(
            color: AppColors.primaryColor,
          ));
        }
        Map<String, List<GetCompany>> groupedData = {};
        for (var item in controller.data) {
          if (groupedData.containsKey(item.tblName)) {
            groupedData[item.tblName]!.add(item);
          } else {
            groupedData[item.tblName.toString()] = [item];
          }
        }
        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: groupedData.keys.length,
          itemBuilder: (context, index) {
            String tblName = groupedData.keys.elementAt(index);
            List<GetCompany> items = groupedData[tblName]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    tblName,
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
                    crossAxisCount: 2, // Number of columns
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 2, // Adjust the height of each grid item
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, itemIndex) {
                    final item = items[itemIndex];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            colors: _getGradientColors(tblName),
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
      'GroupTotals': [Colors.blue, Colors.blueAccent],
      'TotalMonthly': [Colors.orange, Colors.deepOrangeAccent],
      'DocumentStatus': [Colors.pink, Colors.redAccent],
      'DocumentTypes': [Colors.green, Colors.lightGreen],
    };

    // Return default gradient if tblName is not found
    return gradients[tblName] ?? [Colors.grey, Colors.black54];
  }

  // Show a dialog to confirm logout
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
                // Implement logout functionality here
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
