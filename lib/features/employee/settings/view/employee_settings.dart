import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/profile/view/profile_page.dart';
import 'package:presentech/features/employee/settings/controller/employee_setting_controller.dart';
import 'package:presentech/features/views/components/Gradient_btn.dart';
import 'package:presentech/features/views/themes/themes.dart';

class EmployeeSettings extends GetView<EmployeeSettingController> {
  const EmployeeSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: SizedBox(
                  width: 48,
                  height: 48,
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(200),
                    child: Obx(() {
                      return Image.network(
                        controller.profilePictureUrl.value.isNotEmpty
                            ? controller.profilePictureUrl.value
                            : 'https://www.gravatar.com/avatar/?d=mp',
                        fit: BoxFit.cover,
                      );
                    }),
                  ),
                ),
                title: Obx(
                  () =>
                      Text(controller.name.value, style: AppTextStyle.heading1),
                ),
                subtitle: Obx(
                  () => Text(
                    controller.role.value,
                    style: AppTextStyle.normal.copyWith(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("Pengaturan umum", style: AppTextStyle.heading1),
              SizedBox(height: 20),
              ListTile(
                onTap: () {
                  Get.to(
                    () => const ProfilePage(),
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
                contentPadding: EdgeInsets.all(0),
                leading: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.yellowPrimary.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_pin,
                    color: AppColors.yellowPrimary,
                  ),
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
          ),
        ),
      ),
    );
  }
}
