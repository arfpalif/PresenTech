import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/shared/styles/color_style.dart';

class FailedSnackbar {
  static void show(String message) {
    if (Get.testMode) {
      debugPrint('FailedSnackbar suppressed in test mode: $message');
      return;
    }
    Get.snackbar(
      "Failed",
      message,
      backgroundColor: ColorStyle.redPrimary,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      icon: const Icon(Icons.error_outline, color: Colors.white, size: 28),
      duration: const Duration(seconds: 3),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }
}
