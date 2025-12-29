import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/permissions/controller/employee_permission_controller.dart';
import 'package:presentech/shared/controllers/navigation_controller.dart';
import 'package:presentech/features/employee/homepage/view/ui/employee_homepage.dart';
import 'package:presentech/features/employee/homepage/controllers/employee_homepage_controller.dart';
import 'package:presentech/features/employee/permissions/view/employee_permission.dart';
import 'package:presentech/features/employee/tasks/controller/employee_task_controller.dart';
import 'package:presentech/features/employee/settings/controller/employee_setting_controller.dart';
import 'package:presentech/features/employee/settings/view/ui/employee_settings.dart';
import 'package:presentech/features/employee/tasks/view/employee_task.dart';
import 'package:presentech/shared/view/themes/themes.dart';

class EmployeeBottomNav extends StatelessWidget {
  EmployeeBottomNav({super.key}) {
    Get.lazyPut(() => EmployeeHomepageController(), fenix: true);
    Get.lazyPut(() => EmployeePermissionController(), fenix: true);
    Get.lazyPut(() => EmployeeSettingController(), fenix: true);
    Get.lazyPut(() => EmployeeTaskController(), fenix: true);
  }

  NavigationController get navC => Get.find<NavigationController>();

  List<Widget> get pages => [
    const EmployeeHomepage(),
    EmployeePermission(),
    const EmployeeTask(),
    EmployeeSettings(),
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
