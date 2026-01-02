import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/features/auth/login/repositories/login_repository.dart';
import 'package:presentech/shared/view/widgets/hrd_bottom_nav.dart';

class LoginController extends GetxController {
  // import repo
  final loginRepo = LoginRepository();

  // declare variables
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> handleLogin() async {
    try {
      final response = await loginRepo.login(
        emailController.text,
        passwordController.text,
      );
      final user = response.user;
      if (user == null) {
        throw Exception("Login failed, check your email and password");
      }
      final role = await loginRepo.getRole(user.id);
      if (role == 'hrd') {
        Get.snackbar(
          "Success",
          "Login successful",
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAllNamed(Routes.hrdNavbar);
        return;
      } else {
        // If role is not 'hrd', navigate to employee navbar
        Get.snackbar(
          "Success",
          "Login successful",
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAllNamed(Routes.employeeNavbar);
        return;
      }
      // Login successful
    } catch (e) {
      Get.snackbar(
        "Error",
        "Unexpected error: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
