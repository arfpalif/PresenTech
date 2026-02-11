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

      if (session != null) {
        debugPrint(
          "SplashController: Supabase session found, checking connectivity",
        );
        try {
          final role = await splashRepo.getRole(session.user.id);
          debugPrint("SplashController: Online role fetched: $role");
          if (role != null) {
            _navigateByRole(role);
            return;
          }
        } catch (e) {
          debugPrint(
            "SplashController: Online fetch failed ($e), using local auth...",
          );
        }
      } else {
        debugPrint("SplashController: No Supabase session found");
      }

      final localAuth = await splashRepo.getLocalAuth();
      debugPrint(
        "SplashController: Local auth check: ${localAuth != null ? 'Found' : 'NULL'}",
      );
      if (localAuth != null && localAuth['role'] != null) {
        debugPrint(
          "SplashController: Using local auth for ${localAuth['email']}",
        );
        _navigateByRole(localAuth['role']);
        return;
      }

      Get.offAllNamed(Routes.onBoarding);
    } catch (e) {
      debugPrint("SplashController handleAuth error: $e");
      Get.offAllNamed(Routes.onBoarding);
    }
  }

  void _navigateByRole(String role) {
    if (role == 'employee') {
      Get.offAllNamed(Routes.employeeNavbar);
    } else {
      Get.offAllNamed(Routes.hrdNavbar);
    }
  }
}
