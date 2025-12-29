import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/homepage/controllers/employee_homepage_controller.dart';
import 'package:presentech/shared/controllers/navigation_controller.dart';
import 'package:presentech/shared/view/themes/themes.dart';

class Header extends GetView<EmployeeHomepageController> {
  Header({super.key});

  NavigationController get navController => Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 35.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Text(
                  "Hi, ${controller.name.value}",
                  style: AppTextStyle.heading1.copyWith(fontSize: 20),
                ),
              ),
              GestureDetector(
                onTap: () {
                  navController.changePage(3);
                },
                child: Obx(() {
                  final imageUrl = controller.profilePic.value;
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: imageUrl.isEmpty
                        ? CircleAvatar(radius: 20, child: Icon(Icons.person))
                        : Image.network(
                            imageUrl,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                  );
                }),
              ),
            ],
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(5),
            child: Image.network(
              "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
              fit: BoxFit.cover,
              width: 40,
              height: 40,
            ),
          ),
          title: Obx(
            () => Text(controller.name.value, style: AppTextStyle.heading1),
          ),
        ),
      ],
    );
  }
}
