import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/auth/controller/auth_controller.dart';
import 'package:presentech/features/views/components/Gradient_btn.dart';
import 'package:presentech/features/employee/auth/view/loginpage.dart';

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
      body: Column(
        children: [
          AppGradientButton(
            text: "Logout",
            onPressed: () {
              signOut();
            },
          ),
        ],
      ),
    );
  }
}
