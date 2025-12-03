import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/controllers/auth_controller.dart';
import 'package:presentech/views/components/Gradient_btn.dart';
import 'package:presentech/views/pages/loginpage.dart';

class HrdHomepage extends StatefulWidget {
  const HrdHomepage({super.key});

  @override
  State<HrdHomepage> createState() => _HrdHomepageState();
}

class _HrdHomepageState extends State<HrdHomepage> {
  final authC = Get.find<AuthController>();
  void signOut() async{
    await authC.signOut();
    Get.offAll(const Loginpage());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, 
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Ini user HRD"),
          SizedBox(height: 10,),
          AppGradientButton(
            text: "Logout", 
            onPressed: signOut
          ),
        ],
      ),
    );
  }
}