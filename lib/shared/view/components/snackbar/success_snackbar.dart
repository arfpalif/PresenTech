import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/shared/styles/color_style.dart';

class SuccessSnackbar {
  static void show(String message) {
    if (Get.testMode) {
      debugPrint('SuccessSnackbar suppressed in test mode: $message');
      return;
    }
    Get.snackbar(
      "Success",
      message,
      backgroundColor: Colors.transparent,
      backgroundGradient: LinearGradient(
        colors: [
          ColorStyle.greenPrimary,
          ColorStyle.greenPrimary.withOpacity(0.8),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      icon: const Icon(
        Icons.check_circle_outline,
        color: Colors.white,
        size: 28,
      ),
      boxShadows: [
        BoxShadow(
          color: ColorStyle.greenPrimary.withOpacity(0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
      duration: const Duration(seconds: 3),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }
}
