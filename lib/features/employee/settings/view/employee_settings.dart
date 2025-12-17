import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/auth/controller/auth_controller.dart';
import 'package:presentech/features/views/components/Gradient_btn.dart';
import 'package:presentech/features/employee/auth/view/loginpage.dart';
import 'package:presentech/features/views/themes/themes.dart';

class EmployeeSettings extends StatelessWidget {
  const EmployeeSettings({super.key});
  void signOut() async {
    final authController = AuthController();
    await authController.signOut();
    Get.offAll(const Loginpage());
  }

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
                leading: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(200),
                  child: Image.network(
                    "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                    width: 48,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  "Alif Raihan Firman Putra",
                  style: AppTextStyle.heading1,
                ),
                subtitle: Text(
                  "UI/UX Designer",
                  style: AppTextStyle.normal.copyWith(color: Colors.grey),
                ),
              ),
              SizedBox(height: 20),
              Text("Pengaturan umum", style: AppTextStyle.heading1),
              SizedBox(height: 20),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                leading: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.colorPrimary.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person, color: AppColors.colorPrimary,)),
                title: Text(
                  "Profil Saya",
                  style: AppTextStyle.normal,
                ),
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
                  child: Icon(Icons.location_pin, color: AppColors.redPrimary,)),
                title: Text(
                  "Lokasi kantor",
                  style: AppTextStyle.normal,
                ),
                trailing: Icon(Icons.arrow_right),
              ),
              SizedBox(height: 20,),
              Text("Pengaturan aplikasi", style: AppTextStyle.heading1,),
              SizedBox(height: 20),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                leading: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.palette, color: Colors.grey,)),
                title: Text(
                  "Tema",
                  style: AppTextStyle.normal,
                ),
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
                  child: Icon(Icons.location_pin, color: AppColors.yellowPrimary,)),
                title: Text(
                  "Bantuan",
                  style: AppTextStyle.normal,
                ),
                trailing: Icon(Icons.arrow_right),
              ),
              SizedBox(height: 30,),
              AppGradientButtonRed(
                text: "Logout",
                onPressed: () {
                  signOut();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
