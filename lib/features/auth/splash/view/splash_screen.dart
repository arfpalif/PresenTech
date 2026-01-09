import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/constants/assets_constant.dart';
import 'package:presentech/features/auth/splash/controller/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AssetsConstans.logo),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
