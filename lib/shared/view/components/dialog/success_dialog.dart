import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/shared/view/components/buttons/gradient_btn.dart';

class SuccessDialog {
  static void show(String title, String message, VoidCallback action) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ColorStyle.greenPrimary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: ColorStyle.greenPrimary,
                  size: 64,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyle.heading1.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyle.normal.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),
              AppGradientButton(
                onPressed: () {
                  Get.back();
                  action();
                },
                text: 'Great!',
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
