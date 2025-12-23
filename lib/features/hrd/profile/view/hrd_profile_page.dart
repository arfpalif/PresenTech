import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:presentech/features/hrd/profile/controllers/hrd_profile_controller.dart';
import 'package:presentech/features/views/components/Gradient_btn.dart';
import 'package:presentech/features/views/themes/themes.dart';

class HrdProfilePage extends GetView<HrdProfileController> {
  const HrdProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.colorPrimary,
        systemNavigationBarColor: AppColors.colorPrimary,
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [_headerSection(), _attendanceSummaryCard(controller)],
          ),
        ),
      ),
    );
  }
}

Widget _headerSection() {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [AppColors.colorPrimary, AppColors.colorSecondary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
    ),
    child: SafeArea(
      bottom: false,
      child: Container(
        height: 120,
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Text(
          "Profile",
          style: AppTextStyle.title.copyWith(color: Colors.white),
        ),
      ),
    ),
  );
}

Widget _attendanceSummaryCard(HrdProfileController controller) {
  return Obx(
    () => Transform.translate(
      offset: const Offset(0, -70),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.isLoading.value)
                const Center(child: CircularProgressIndicator())
              else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: controller.profilePic.value.isEmpty
                          ? const CircleAvatar(
                              radius: 40,
                              child: Icon(Icons.person),
                            )
                          : Image.network(
                              controller.profilePic.value,
                              width: 75,
                              height: 75,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.name.value.isEmpty
                              ? '-'
                              : controller.name.value,
                          style: AppTextStyle.title.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          controller.role.value.isEmpty
                              ? '-'
                              : controller.role.value,
                          style: AppTextStyle.normal.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text("Informasi pribadi", style: AppTextStyle.heading1),
                const SizedBox(height: 10),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.colorPrimary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: AppColors.colorPrimary,
                    ),
                  ),
                  title: Text("Profil Saya", style: AppTextStyle.normal),
                  trailing: const Icon(Icons.arrow_right),
                ),
                const SizedBox(height: 20),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.redPrimary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.location_pin,
                      color: AppColors.redPrimary,
                    ),
                  ),
                  title: Text("Lokasi kantor", style: AppTextStyle.normal),
                  trailing: const Icon(Icons.arrow_right),
                ),
                const SizedBox(height: 20),
                Text("Pengaturan aplikasi", style: AppTextStyle.heading1),
                const SizedBox(height: 20),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.palette, color: Colors.grey),
                  ),
                  title: Text("Tema", style: AppTextStyle.normal),
                  trailing: const Icon(Icons.arrow_right),
                ),
                const SizedBox(height: 20),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.yellowPrimary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.location_pin,
                      color: AppColors.yellowPrimary,
                    ),
                  ),
                  title: Text("Bantuan", style: AppTextStyle.normal),
                  trailing: const Icon(Icons.arrow_right),
                ),
                const SizedBox(height: 30),
                AppGradientButtonRed(text: "Logout", onPressed: () {}),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}

Widget summaryItem(String label) {
  return Column(
    children: [
      Text(label, style: AppTextStyle.normal.copyWith(color: Colors.grey)),
      const SizedBox(height: 8),
    ],
  );
}
