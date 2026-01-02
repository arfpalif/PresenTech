import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/features/auth/login/controller/login_controller.dart';
import 'package:presentech/shared/view/components/Gradient_btn.dart';
import 'package:presentech/shared/view/themes/themes.dart';

class LoginPage extends GetView<LoginController> {
  late final _emailController = controller.emailController;
  late final _passWordController = controller.passwordController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("src/images/ic_signup.svg"),
                SizedBox(height: 20),
                Text(
                  "Login",
                  style: AppTextStyle.heading1.copyWith(color: Colors.black),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Email", style: AppTextStyle.normal),
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  obscureText: false,
                  decoration: InputDecoration(prefixIcon: Icon(Icons.email)),
                ),
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Password", style: AppTextStyle.normal),
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _passWordController,
                  obscureText: true,
                  decoration: InputDecoration(prefixIcon: Icon(Icons.password)),
                ),
                SizedBox(height: 30),
                AppGradientButton(
                  text: "Login",
                  onPressed: () {
                    controller.handleLogin();
                  },
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Get.offAllNamed(Routes.register);
                  },
                  child: Text(
                    "Sudah memiliki akun ? Login",
                    style: AppTextStyle.normal.copyWith(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
