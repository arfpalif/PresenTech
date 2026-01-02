import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/profile/controller/profile_controller.dart';
import 'package:presentech/features/employee/profile/view/components/card_header.dart';
import 'package:presentech/features/employee/settings/model/user.dart';
import 'package:presentech/shared/view/themes/themes.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProfile user = Get.arguments as UserProfile;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarColor: Colors.white),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: CardHeader(
                    imageUrl: user.profilePicture,
                    name: user.name,
                    role: user.role,
                  ),
                ),
                SizedBox(height: 20),
                Text("Informasi Personal", style: AppTextStyle.heading1),
                SizedBox(height: 10),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.colorPrimary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.person, color: AppColors.colorPrimary),
                  ),
                  title: Text(
                    "Email",
                    style: AppTextStyle.normal.copyWith(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                  subtitle: Text(user.email, style: AppTextStyle.heading1),
                ),
                SizedBox(height: 10),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.colorPrimary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.business, color: AppColors.colorPrimary),
                  ),
                  title: Text(
                    "Lokasi Kantor",
                    style: AppTextStyle.normal.copyWith(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                  subtitle: Text(
                    "${user.officeId}",
                    style: AppTextStyle.heading1,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.colorPrimary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.date_range,
                      color: AppColors.colorPrimary,
                    ),
                  ),
                  title: Text(
                    "Tanggal bergabung",
                    style: AppTextStyle.normal.copyWith(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                  subtitle: Text(
                    "${user.createdAt}",
                    style: AppTextStyle.heading1,
                  ),
                ),
                Divider(color: Colors.grey.shade300, thickness: 1, height: 24),
                Text("Jadwal kerja", style: AppTextStyle.heading1),
                SizedBox(height: 10),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.colorPrimary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.schedule, color: AppColors.colorPrimary),
                  ),
                  title: Text("Senin - Jumat", style: AppTextStyle.heading1),
                  subtitle: Text(
                    "09.00 - 17.00 WIB",
                    style: AppTextStyle.normal.copyWith(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
