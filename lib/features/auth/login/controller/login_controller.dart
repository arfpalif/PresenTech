import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/constants/api_constant.dart';
import 'package:presentech/shared/repositories/auth_repository.dart';
import 'package:presentech/shared/view/components/snackbar/failed_snackbar.dart';
import 'package:presentech/shared/view/components/snackbar/success_snackbar.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/features/auth/login/repositories/login_repository.dart';
import 'package:presentech/features/employee/homepage/controllers/employee_homepage_controller.dart';
import 'package:presentech/features/employee/permissions/controller/employee_permission_controller.dart';
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

      print("LoginController: Preparing to save auth locally...");
      final authRepo = AuthRepository();
      await authRepo.saveAuthData({
        'id': user.id,
        'email': user.email,
        'role': role,
      });
      print(
        "LoginController: Auth data saved locally successfully to ${ApiConstant.tableAuth}.",
      );
      print("LoginController: Auth data saved locally successfully.");

      if (role == 'hrd') {
        SuccessSnackbar.show("Login successful");
        Get.delete<EmployeeHomepageController>();
        Get.delete<EmployeePermissionController>();
        Get.delete<EmployeeTaskController>();
        Get.offAllNamed(Routes.hrdNavbar);
        return;
      } else {
        SuccessSnackbar.show("Login successful");
        Get.delete<HrdHomepageController>();
        Get.delete<HrdAttendanceController>();
        Get.delete<HrdEmployeeController>();
        Get.delete<HrdProfileController>();
        Get.delete<HrdPermissionController>();
        Get.delete<LocationController>();
        Get.offAllNamed(Routes.employeeNavbar);
        return;
      }
    } catch (e) {
      FailedSnackbar.show("Unexpected error: $e");
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
