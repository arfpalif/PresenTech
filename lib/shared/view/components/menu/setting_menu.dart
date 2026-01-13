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
        Text("Pengaturan umum", style: AppTextStyle.heading1),
        SizedBox(height: 20),
        ListTile(
          onTap: () {
            Get.toNamed(Routes.employeeProfile);
          },
          contentPadding: EdgeInsets.all(0),
          leading: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ColorStyle.colorPrimary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person, color: ColorStyle.colorPrimary),
          ),
          title: Text("Profil Saya", style: AppTextStyle.normal),
          trailing: Icon(Icons.arrow_right),
        ),
        SizedBox(height: 20),
        ListTile(
          onTap: () {
            Get.toNamed(Routes.comingSoon);
          },
          contentPadding: EdgeInsets.all(0),
          leading: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ColorStyle.redPrimary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.location_pin, color: ColorStyle.redPrimary),
          ),
          title: Text("Lokasi kantor", style: AppTextStyle.normal),
          trailing: Icon(Icons.arrow_right),
        ),
        SizedBox(height: 20),
        Text("Pengaturan aplikasi", style: AppTextStyle.heading1),
        SizedBox(height: 20),
        ListTile(
          onTap: () {
            Get.toNamed(Routes.comingSoon);
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
            Get.toNamed(Routes.comingSoon);
          },
          contentPadding: EdgeInsets.all(0),
          leading: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ColorStyle.yellowPrimary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.location_pin, color: ColorStyle.yellowPrimary),
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
