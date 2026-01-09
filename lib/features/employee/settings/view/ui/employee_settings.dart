import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/settings/controller/employee_setting_controller.dart';
import 'package:presentech/features/employee/settings/view/components/setting_menu.dart';
import 'package:presentech/shared/controllers/navigation_controller.dart';
import 'package:presentech/shared/view/ui/coming_soon.dart';
import 'package:presentech/shared/view/widgets/header.dart';

class EmployeeSettings extends GetView<EmployeeSettingController> {
  EmployeeSettings({super.key});
  final NavigationController navController = Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Header(
                height: 180,
                onComingSoonTap: () => Get.to(ComingSoon()),
                imageUrl: controller.profilePictureUrl.value,
                name: controller.name.value,
                role: controller.role.value,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SettingMenu(),
            ),
          ],
        ),
      ),
    );
  }
}
