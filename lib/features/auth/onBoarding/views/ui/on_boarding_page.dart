import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/constants/assets_constant.dart';
import 'package:presentech/features/auth/onBoarding/controllers/on_boarding_controller.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/shared/view/components/buttons/gradient_btn.dart';

class OnBoardingPage extends GetView<OnBoardingController> {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.whiteSecondary,
      body: Stack(
        children: [
          // Background Decoration
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    ColorStyle.colorPrimary.withOpacity(0.1),
                    ColorStyle.colorSecondary.withOpacity(0.05),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Image with subtle shadow or container if needed
                  Hero(
                    tag: 'onboarding_img',
                    child: Image.asset(
                      AssetsConstans.imgOnBoarding,
                      height: MediaQuery.of(context).size.height * 0.4,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "Manage attendance and HRD systems easily",
                    style: AppTextStyle.title.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: ColorStyle.colorSecondary,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Manage HRD systems, attendance and employee easily anywhere, everywhere.",
                    style: AppTextStyle.normal.copyWith(
                      color: Colors.black.withOpacity(0.6),
                      fontSize: 15,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  const SizedBox(height: 40),
                  AppGradientButton(
                    text: "Get Started",
                    onPressed: () => Get.toNamed(Routes.login),
                    borderRadius: 30,
                    height: 56,
                    textStyle: AppTextStyle.title.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppOutlinedButton(
                    borderRadius: 30,
                    height: 56,
                    text: "I’m new, sign me up",
                    textStyle: AppTextStyle.title.copyWith(
                      color: ColorStyle.colorPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    onPressed: () => Get.toNamed(Routes.register),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
