import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/shared/controllers/navigation_controller.dart';
import 'package:presentech/features/hrd/employee/view/ui/hrd_employee.dart';
import 'package:presentech/features/hrd/homepage/view/ui/hrd_homepage.dart';
import 'package:presentech/features/hrd/permission/view/ui/hrd_permission.dart';
import 'package:presentech/features/hrd/location/view/ui/hrd_location.dart';
import 'package:presentech/features/hrd/profile/view/ui/hrd_profile_page.dart';
import 'package:presentech/shared/styles/color_style.dart';

import 'package:presentech/shared/view/widgets/lazy_indexed_stack.dart';

class HrdBottomNav extends GetView<NavigationController> {
  const HrdBottomNav({super.key});

  List<Widget> get pages => [
    HrdHomepage(),
    HrdPermission(),
    HrdEmployee(),
    const HrdLocation(),
    HrdProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => LazyIndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          selectedItemColor: ColorStyle.colorSecondary,
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
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
