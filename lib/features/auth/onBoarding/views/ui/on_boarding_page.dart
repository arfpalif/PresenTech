import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/constants/assets_constant.dart';
import 'package:presentech/features/auth/onBoarding/controllers/on_boarding_controller.dart';
import 'package:presentech/shared/view/components/buttons/gradient_btn.dart';

class OnBoardingPage extends GetView<OnBoardingController> {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AssetsConstans.imgOnBoarding, height: 400),
              SizedBox(height: 10),
              Text(
                "Manage attendance and HRD systems easily",
                style: AppTextStyle.heading1.copyWith(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "Manage HRD systems, attendance and employee easily anywhere, everywhere.",
                style: AppTextStyle.normal.copyWith(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 80),
              AppGradientButton(
                text: "Get Started",
                onPressed: () => Get.toNamed(Routes.login),
                borderRadius: 20,
              ),
              SizedBox(height: 10),
              AppOutlinedButton(
                borderRadius: 20,
                text: "I’m new, sign me up",
                onPressed: () => Get.toNamed(Routes.register),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
