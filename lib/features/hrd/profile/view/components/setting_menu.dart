import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/features/hrd/profile/controllers/hrd_profile_controller.dart';
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
        _buildSettingItem(
          icon: Icons.person_rounded,
          color: ColorStyle.colorPrimary,
          title: "My Profile",
          onTap: () => Get.toNamed(Routes.employeeProfile),
        ),
        SizedBox(height: 16),
        _buildSettingItem(
          icon: Icons.business_rounded,
          color: ColorStyle.redPrimary,
          title: "Office Locations",
           onTap: () => Get.toNamed(Routes.comingSoon),
        ),
        SizedBox(height: 32),
        Text("App Settings", style: AppTextStyle.heading1),
        SizedBox(height: 16),
        _buildSettingItem(
          icon: Icons.palette_rounded,
          color: Colors.grey,
          title: "Theme",
           onTap: () => Get.toNamed(Routes.comingSoon),
        ),
        SizedBox(height: 16),
        _buildSettingItem(
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

  Widget _buildSettingItem({
    required IconData icon,
    required Color color,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: AppTextStyle.normal.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
      ),
    );
  }
}
