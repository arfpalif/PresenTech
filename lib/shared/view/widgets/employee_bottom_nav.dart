import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/permissions/view/ui/employee_permission.dart';
import 'package:presentech/shared/controllers/navigation_controller.dart';
import 'package:presentech/features/employee/homepage/view/ui/employee_homepage.dart';
import 'package:presentech/features/employee/settings/view/ui/employee_settings.dart';
import 'package:presentech/features/employee/tasks/view/ui/employee_task.dart';
import 'package:presentech/shared/view/themes/themes.dart';

class EmployeeBottomNav extends GetView<NavigationController> {
  EmployeeBottomNav({super.key});

  List<Widget> get pages => [
    EmployeeHomepage(),
    EmployeePermission(),
    const EmployeeTask(),
    EmployeeSettings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () =>
            IndexedStack(index: controller.currentIndex.value, children: pages),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 50),
          ],
        ),
        child: Obx(
          () => BottomNavigationBar(
            elevation: 0,
            currentIndex: controller.currentIndex.value,
            onTap: controller.changePage,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.colorSecondary.withOpacity(0.9),
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
      ),
    );
  }
}
