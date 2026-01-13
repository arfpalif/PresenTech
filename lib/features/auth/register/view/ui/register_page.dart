import 'package:flutter/material.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:presentech/constants/assets_constant.dart';
import 'package:presentech/features/auth/register/controller/register_controller.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/shared/view/components/buttons/gradient_btn.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/shared/view/components/textFields/text_field_outlined.dart';

// ignore: must_be_immutable
class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({super.key});

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
                   Text(
                    "Create Account",
                    style: AppTextStyle.heading1.copyWith(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Start your journey with us",
                    style: AppTextStyle.normal.copyWith(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 30),

                  // Register Form Card
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Full Name", style: AppTextStyle.normal.copyWith(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        TextFieldOutlined(
                          keyboardType: TextInputType.name,
                          controller: controller.nameController,
                          onChanged: (value) => controller.validateForm(),
                          decoration: _inputDecoration(hint: "Enter your full name", icon: Icons.person_outline),
                          icon: Icon(Icons.person),
                        ),
                        SizedBox(height: 20),

                        Text("Email Address", style: AppTextStyle.normal.copyWith(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        TextFieldOutlined(
                          keyboardType: TextInputType.emailAddress,
                          controller: controller.emailController,
                          obscureText: false,
                          decoration: _inputDecoration(hint: "Enter your email", icon: Icons.email_outlined),
                          icon: Icon(Icons.email),
                        ),
                        SizedBox(height: 20),

                        Text("Password", style: AppTextStyle.normal.copyWith(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        TextFieldOutlined(
                          keyboardType: TextInputType.visiblePassword,
                          controller: controller.passwordController,
                          onChanged: (value) => controller.validateForm(),
                          obscureText: true,
                          decoration: _inputDecoration(hint: "Create a password", icon: Icons.lock_outline),
                          icon: Icon(Icons.lock),
                        ),
                        SizedBox(height: 20),

                        Text("Select Role", style: AppTextStyle.normal.copyWith(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          decoration: _inputDecoration(hint: "", icon: Icons.work_outline).copyWith(
                             contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                             prefixIcon: null, // Remove prefix icon for dropdown if preferred or keep it
                          ),
                          icon: Icon(Icons.keyboard_arrow_down_rounded),
                          initialValue: controller.role,
                          hint: const Text("Choose your role"),
                          isExpanded: true,
                          onChanged: (String? newValue) {
                            controller.role = newValue!;
                            controller.update();
                          },
                          items: [
                            DropdownMenuItem(value: "hrd", child: Text("HRD")),
                            DropdownMenuItem(value: "employee", child: Text("Employee")),
                          ],
                        ),
                        SizedBox(height: 32),

                        Obx(
                          () => controller.isFormValid.value
                              ? AppGradientButton(
                                  borderRadius: 16,
                                  text: "Sign Up",
                                  onPressed: () {
                                    controller.handleRegister();
                                  },
                                )
                              : AppDeactivatedButton(
                                  borderRadius: 16,
                                  text: "Sign Up",
                                  onPressed: () {},
                                ),
                        ),
                        SizedBox(height: 20),
                        
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

                        AppOutlinedButton(
                          borderRadius: 16,
                          icon: Image.asset(AssetsConstans.imgGoogle, height: 24),
                          text: "Register with Google",
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),

                  GestureDetector(
                    onTap: () {
                      Get.offAllNamed(Routes.login);
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: AppTextStyle.normal.copyWith(color: Colors.grey[600]),
                        children: [
                          TextSpan(
                            text: "Login",
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
