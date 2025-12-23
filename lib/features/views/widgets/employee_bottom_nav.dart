import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/homepage/controller/navigation_controller.dart';
import 'package:presentech/features/employee/homepage/view/employee_homepage.dart';
import 'package:presentech/features/employee/permissions/view/employee_permission.dart';
import 'package:presentech/features/employee/tasks/controller/employee_task_controller.dart';
import 'package:presentech/features/employee/settings/controller/employee_setting_controller.dart';
import 'package:presentech/features/employee/settings/view/employee_settings.dart';
import 'package:presentech/features/employee/tasks/view/employee_task.dart';
import 'package:presentech/features/views/themes/themes.dart';

class EmployeeBottomNav extends StatelessWidget {
  EmployeeBottomNav({super.key}) {
    // Pastikan controller sudah tersedia saat widget pertama kali dibuat
    Get.lazyPut(() => EmployeeSettingController(), fenix: true);
    Get.lazyPut(() => EmployeeTaskController(), fenix: true);
  }

  final NavigationController navC = Get.find<NavigationController>();

  final List<Widget> pages = [
    const EmployeeHomepage(),
    const EmployeePermission(),
    const EmployeeTask(),
    const EmployeeSettings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(index: navC.currentIndex.value, children: pages),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: navC.currentIndex.value,
          onTap: navC.changePage,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.colorSecondary,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.date_range),
              label: 'Permission',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Pengaturan',
            ),
          ],
        ),
      ),
    );
  }
}
