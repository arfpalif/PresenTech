import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/features/auth/login/repositories/login_repository.dart';
import 'package:presentech/features/employee/homepage/controllers/employee_homepage_controller.dart';
import 'package:presentech/features/employee/permissions/controller/employee_permission_controller.dart';
import 'package:presentech/features/employee/settings/controller/employee_setting_controller.dart';
import 'package:presentech/features/employee/tasks/controller/employee_task_controller.dart';
import 'package:presentech/features/hrd/attendance/controller/hrd_attendance_controller.dart';
import 'package:presentech/features/hrd/employee/controller/hrd_employee_controller.dart';
import 'package:presentech/features/hrd/homepage/controller/hrd_homepage_controller.dart';
import 'package:presentech/features/hrd/location/controller/location_controller.dart';
import 'package:presentech/features/hrd/permission/controller/hrd_permission_controller.dart';
import 'package:presentech/features/hrd/profile/controllers/hrd_profile_controller.dart';

class LoginController extends GetxController {
  // import repo
  final loginRepo = LoginRepository();

  // declare controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //variables
  RxBool isFormValid = false.obs;

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
        Get.delete<EmployeeHomepageController>();
        Get.delete<EmployeePermissionController>();
        Get.delete<EmployeeSettingController>();
        Get.delete<EmployeeTaskController>();
        Get.offAllNamed(Routes.hrdNavbar);
        return;
      } else {
        // If role is not 'hrd', navigate to employee navbar
        Get.snackbar(
          "Success",
          "Login successful",
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.delete<HrdHomepageController>();
        Get.delete<HrdAttendanceController>();
        Get.delete<HrdEmployeeController>();
        Get.delete<HrdProfileController>();
        Get.delete<HrdPermissionController>();
        Get.delete<LocationController>();
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

  void validateForm() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      isFormValid.value = true;
    } else {
      isFormValid.value = false;
    }
  }
}
