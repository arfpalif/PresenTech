import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/features/auth/register/repositories/register_repository.dart';

class RegisterController extends GetxController {
  final registerRepo = Get.find<RegisterRepository>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  String? role;

  Future<void> handleRegister() async {
    // Implement registration logic here
    try {
      final response = await registerRepo.signUp(
        emailController.text,
        passwordController.text,
      );
      final user = response.user;
      if (user == null) {
        throw Exception("Registration failed, please try again");
      }
      final userRole = await registerRepo.getRole(user.id);
      if (userRole == 'hrd') {
        Get.snackbar(
          "Success",
          "Login successful",
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAll(Routes.hrdNavbar);
        return;
      } else {
        Get.snackbar(
          "Success",
          "Login successful",
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAllNamed(Routes.employeeNavbar);
        return;
      } // Navigate back to the previous screen
    } catch (e) {
      Get.snackbar(
        "Error",
        "Unexpected error: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
