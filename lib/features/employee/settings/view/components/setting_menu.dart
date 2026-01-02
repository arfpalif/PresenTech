import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/features/employee/settings/controller/employee_setting_controller.dart';
import 'package:presentech/shared/view/components/Gradient_btn.dart';
import 'package:presentech/shared/view/themes/themes.dart';
import 'package:presentech/shared/view/ui/coming_soon.dart';

class SettingMenu extends GetView<EmployeeSettingController> {
  const SettingMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Pengaturan umum", style: AppTextStyle.heading1),
        SizedBox(height: 20),
        ListTile(
          onTap: () {
            Get.toNamed(
              Routes.employeeProfile,
              arguments: controller.user.value,
            );
          },
          contentPadding: EdgeInsets.all(0),
          leading: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.colorPrimary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person, color: AppColors.colorPrimary),
          ),
          title: Text("Profil Saya", style: AppTextStyle.normal),
          trailing: Icon(Icons.arrow_right),
        ),
        SizedBox(height: 20),
        ListTile(
          onTap: () {
            Get.to(ComingSoon());
          },
          contentPadding: EdgeInsets.all(0),
          leading: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.redPrimary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.location_pin, color: AppColors.redPrimary),
          ),
          title: Text("Lokasi kantor", style: AppTextStyle.normal),
          trailing: Icon(Icons.arrow_right),
        ),
        SizedBox(height: 20),
        Text("Pengaturan aplikasi", style: AppTextStyle.heading1),
        SizedBox(height: 20),
        ListTile(
          onTap: () {
            Get.to(ComingSoon());
          },
          contentPadding: EdgeInsets.all(0),
          leading: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.palette, color: Colors.grey),
          ),
          title: Text("Tema", style: AppTextStyle.normal),
          trailing: Icon(Icons.arrow_right),
        ),
        SizedBox(height: 20),
        ListTile(
          onTap: () {
            Get.to(ComingSoon());
          },
          contentPadding: EdgeInsets.all(0),
          leading: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.yellowPrimary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.location_pin, color: AppColors.yellowPrimary),
          ),
          title: Text("Bantuan", style: AppTextStyle.normal),
          trailing: Icon(Icons.arrow_right),
        ),
        SizedBox(height: 30),
        AppGradientButtonRed(
          text: "Logout",
          onPressed: () {
            controller.signOut();
          },
        ),
      ],
    );
  }
}
