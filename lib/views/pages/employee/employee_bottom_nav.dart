import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/controllers/navigation_controller.dart';
import 'package:presentech/views/pages/employee/employee_homepage.dart';
import 'package:presentech/views/pages/employee/employee_permission.dart';
import 'package:presentech/views/pages/employee/employee_reports.dart';
import 'package:presentech/views/pages/employee/employee_settings.dart';

class EmployeeBottomNav extends StatelessWidget {
  EmployeeBottomNav({super.key});

  final NavigationController navC = Get.find<NavigationController>();

  final List<Widget> pages = [
    EmployeeHomepage(),
    EmployeeReports(),
    EmployeeSettings(),
    EmployeePermission()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
        index: navC.currentIndex.value,
        children: pages,
      )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: navC.currentIndex.value,
        onTap: navC.changePage,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Permission'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Pengaturan'),
        ],
      )),
    );
  }
}