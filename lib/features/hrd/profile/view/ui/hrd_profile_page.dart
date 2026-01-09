import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/features/hrd/profile/controllers/hrd_profile_controller.dart';
import 'package:presentech/features/hrd/profile/view/components/setting_menu.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/shared/view/widgets/header.dart';

class HrdProfilePage extends GetView<HrdProfileController> {
  const HrdProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Color(0xFFF5F7FA),
        body: Column(
          children: [
            Obx(
              () => Header(
                height: 170,
                onComingSoonTap: () {
                  Get.toNamed(Routes.comingSoon);
                },
                imageUrl: controller.profilePic.value,
                name: controller.name.value,
                role: controller.role.value,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(children: [SettingMenu()]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget summaryItem(String label) {
  return Column(
    children: [
      Text(label, style: AppTextStyle.normal.copyWith(color: Colors.grey)),
      const SizedBox(height: 8),
    ],
  );
}
