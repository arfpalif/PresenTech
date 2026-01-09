import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/constants/assets_constant.dart';
import 'package:presentech/features/auth/login/controller/login_controller.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/shared/view/components/buttons/gradient_btn.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/shared/view/components/textFields/text_field_outlined.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: Stack(
        children: [
          // Background Gradient Top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[ColorStyle.colorPrimary, ColorStyle.greenPrimary],
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Logo or Title Section above card
                   Text(
                    "Presentech",
                    style: AppTextStyle.heading1.copyWith(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Manage your work easily",
                    style: AppTextStyle.normal.copyWith(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 40),

                  // Login Form Card
                  Container(
                    padding: const EdgeInsets.all(32),
                     decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome Back!",
                          style: AppTextStyle.heading1.copyWith(
                            color: Colors.black87,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Please login to your account",
                          style: AppTextStyle.normal.copyWith(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 32),
                        
                        // Email Input
                        Text("Email Address", style: AppTextStyle.normal.copyWith(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        TextFieldOutlined(
                          keyboardType: TextInputType.emailAddress,
                          controller: controller.emailController,
                          obscureText: false,
                          decoration: _inputDecoration(hint: "Enter your email", icon: Icons.email_outlined),
                          icon: Icon(Icons.email), // Kept for compatibility if required by widget
                        ),
                        SizedBox(height: 24),

                        // Password Input
                        Text("Password", style: AppTextStyle.normal.copyWith(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        TextFieldOutlined(
                          keyboardType: TextInputType.visiblePassword,
                          controller: controller.passwordController,
                          onChanged: (value) => controller.validateForm(),
                          obscureText: true,
                          decoration: _inputDecoration(hint: "Enter your password", icon: Icons.lock_outline),
                          icon: Icon(Icons.lock), // Kept for compatibility
                        ),
                        
                        SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              // Forgot password logic
                            },
                            child: Text(
                              "Forgot Password?",
                              style: AppTextStyle.normal.copyWith(
                                color: ColorStyle.colorPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 32),

                        // Login Button
                         Obx(
                          () => controller.isFormValid.value
                              ? AppGradientButton(
                                  borderRadius: 16,
                                  text: "Login",
                                  onPressed: () {
                                    controller.handleLogin();
                                  },
                                )
                              : AppDeactivatedButton(
                                  borderRadius: 16,
                                  text: "Login",
                                  onPressed: () {},
                                ),
                        ),
                         SizedBox(height: 20),
                         
                         // Divider
                         Row(
                           children: [
                             Expanded(child: Divider(color: Colors.grey[300])),
                             Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 16),
                               child: Text("OR", style: TextStyle(color: Colors.grey)),
                             ),
                             Expanded(child: Divider(color: Colors.grey[300])),
                           ],
                         ),
                         SizedBox(height: 20),

                        // Google Login
                        AppOutlinedButton(
                          icon: Image.asset(AssetsConstans.imgGoogle, height: 24),
                          borderRadius: 16,
                          text: "Login with Google",
                          onPressed: () {
                            // Add your Google login logic here
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  
                  // Register Link
                  GestureDetector(
                    onTap: () {
                      Get.offAllNamed(Routes.register);
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Don’t have an account? ",
                        style: AppTextStyle.normal.copyWith(color: Colors.grey[600]),
                        children: [
                          TextSpan(
                            text: "Register Now",
                            style: AppTextStyle.heading1.copyWith(
                              color: ColorStyle.colorPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: ColorStyle.colorPrimary),
      ),
    );
  }
}
