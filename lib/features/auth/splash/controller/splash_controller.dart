import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/features/auth/splash/repositories/splash_repository.dart';

class SplashController extends GetxController {
  final SplashRepository splashRepo;
  SplashController(this.splashRepo);

  @override
  void onReady() {
    super.onReady();
    handleAuth();
  }

  Future<void> handleAuth() async {
    try {
      final session = splashRepo.getSession();

      if (session == null) {
        Get.offAllNamed(Routes.onBoarding);
      } else {
        final role = await splashRepo.getRole(session.user.id);
        if (role == null) {
          Get.offAllNamed(Routes.onBoarding);
        } else {
          role == 'employee'
              ? Get.offAllNamed(Routes.employeeNavbar)
              : Get.offAllNamed(Routes.hrdNavbar);
        }
      }
    } catch (e) {
      debugPrint("SplashController handleAuth error: $e");
      Get.offAllNamed(Routes.onBoarding);
    }
  }
}
