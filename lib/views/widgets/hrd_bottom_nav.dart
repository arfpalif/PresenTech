import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/controllers/navigation_controller.dart';
import 'package:presentech/views/pages/hrd/hrd_homepage.dart';
import 'package:presentech/views/pages/hrd/hrd_reports.dart';
import 'package:presentech/views/pages/hrd/hrd_location.dart';

class HrdBottomNav extends StatelessWidget {
  HrdBottomNav({super.key});

  final NavigationController navC = Get.find<NavigationController>();

  final List<Widget> pages = [
    HrdHomepage(),
    HrdReports(),
    HrdLocation(),
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
              BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Location'),
            ],
          )),
    );
  }
}
