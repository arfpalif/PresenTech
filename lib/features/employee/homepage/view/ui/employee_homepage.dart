import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/homepage/controllers/employee_homepage_controller.dart';
import 'package:presentech/features/employee/homepage/view/components/absence_list_homepage.dart';
import 'package:presentech/features/employee/homepage/view/components/card_absence.dart';
import 'package:presentech/features/employee/homepage/view/components/menu.dart';
import 'package:presentech/features/employee/homepage/view/components/task_list_homepage.dart';
import 'package:presentech/shared/controllers/navigation_controller.dart';
import 'package:presentech/shared/controllers/profile_controller.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/shared/view/ui/coming_soon.dart';
import 'package:presentech/shared/view/widgets/header.dart';

class EmployeeHomepage extends GetView<EmployeeHomepageController> {
  EmployeeHomepage({super.key});
  final NavigationController navController = Get.find<NavigationController>();
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: ColorStyle.whiteSecondary,
        body: Column(
          children: [
            Obx(() {
              return Header(
                onChangePage: () {
                  navController.changePage(3);
                },
                onComingSoonTap: () {
                  Get.to(ComingSoon());
                },
                imageUrl: profileController.profilePictureUrl.value,
                name: profileController.name.value,
                role: profileController.role.value,
              );
            }),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      SizedBox(height: 24),
                      CardAbsence(),
                      SizedBox(height: 32),
                      Menu(),
                      SizedBox(height: 32),
                      AbsenceListHomepage(),
                      SizedBox(height: 32),
                      TaskListHomepage(),
                      SizedBox(height: 100), // Bottom padding
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
