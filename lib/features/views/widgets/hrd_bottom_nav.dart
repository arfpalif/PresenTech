import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/homepage/controller/navigation_controller.dart';
import 'package:presentech/features/hrd/employee/view/hrd_employee.dart';
import 'package:presentech/features/hrd/homepage/view/hrd_homepage.dart';
import 'package:presentech/features/hrd/permission/controller/hrd_permission_controller.dart';
import 'package:presentech/features/hrd/permission/view/hrd_permission.dart';
import 'package:presentech/features/hrd/location/view/hrd_location.dart';
import 'package:presentech/features/hrd/profile/controllers/hrd_profile_controller.dart';
import 'package:presentech/features/hrd/profile/view/hrd_profile_page.dart';
import 'package:presentech/features/views/themes/themes.dart';
import 'package:presentech/features/hrd/location/controller/location_controller.dart';

class HrdBottomNav extends StatelessWidget {
  HrdBottomNav({super.key}) {
    Get.lazyPut(() => HrdProfileController(), fenix: true);
    Get.lazyPut(() => HrdPermissionController(), fenix: true);
    Get.lazyPut(() => LocationController(), fenix: true);
  }
  final NavigationController navC = Get.find<NavigationController>();

  final List<Widget> pages = [
    HrdHomepage(),
    HrdPermission(),
    HrdEmployee(),
    HrdLocation(),
    HrdProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(index: navC.currentIndex.value, children: pages),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          selectedItemColor: AppColors.colorSecondary,
          currentIndex: navC.currentIndex.value,
          onTap: navC.changePage,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.email),
              label: 'Permissions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Employees',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              label: 'Location',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
