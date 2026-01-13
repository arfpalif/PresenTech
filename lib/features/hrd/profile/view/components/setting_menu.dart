import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/features/hrd/profile/controllers/hrd_profile_controller.dart';
import 'package:presentech/features/hrd/profile/view/components/setting_item.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/shared/view/components/buttons/gradient_btn.dart';
import 'package:presentech/configs/themes/themes.dart';

class SettingMenu extends GetView<HrdProfileController> {
  const SettingMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("General Settings", style: AppTextStyle.heading1),
        SizedBox(height: 16),
        buildSettingItem(
          icon: Icons.person_rounded,
          color: ColorStyle.colorPrimary,
          title: "My Profile",
          onTap: () => Get.toNamed(Routes.employeeProfile),
        ),
        SizedBox(height: 16),
        buildSettingItem(
          icon: Icons.business_rounded,
          color: ColorStyle.redPrimary,
          title: "Office Locations",
          onTap: () => Get.toNamed(Routes.comingSoon),
        ),
        SizedBox(height: 32),
        Text("App Settings", style: AppTextStyle.heading1),
        SizedBox(height: 16),
        buildSettingItem(
          icon: Icons.palette_rounded,
          color: Colors.grey,
          title: "Theme",
          onTap: () => Get.toNamed(Routes.comingSoon),
        ),
        SizedBox(height: 16),
        buildSettingItem(
          icon: Icons.help_rounded,
          color: ColorStyle.yellowPrimary,
          title: "Help & Support",
          onTap: () => Get.toNamed(Routes.comingSoon),
        ),
        SizedBox(height: 40),
        AppGradientButtonRed(
          text: "Logout",
          onPressed: () {
            controller.signOut();
          },
        ),
        SizedBox(height: 40),
      ],
    );
  }
}
