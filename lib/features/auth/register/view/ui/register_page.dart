import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:presentech/features/auth/register/controller/register_controller.dart';
import 'package:presentech/shared/view/components/Gradient_btn.dart';
import 'package:presentech/shared/view/themes/themes.dart';

// ignore: must_be_immutable
class RegisterPage extends GetView<RegisterController> {
  late final _emailController = controller.emailController;
  late final _passWordController = controller.passwordController;
  late final _nameController = controller.nameController;
  String? selectedValue;

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.00),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 32,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SvgPicture.asset("src/images/ic_signup.svg"),
                  SizedBox(height: 20),
                  Text("Daftar Akun", style: AppTextStyle.heading1),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Email", style: AppTextStyle.normal),
                  ),
                  TextFormField(
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
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _passWordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password),
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Nama", style: AppTextStyle.normal),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _nameController,
                    obscureText: false,
                    decoration: InputDecoration(prefixIcon: Icon(Icons.person)),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Select role", style: AppTextStyle.normal),
                  ),
                  DropdownButton<String>(
                    value: selectedValue,
                    hint: const Text("Pilih Role"),
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      selectedValue = newValue;
                      controller.role = newValue!;
                      controller.update();
                    },
                    items: [
                      DropdownMenuItem(value: "hrd", child: Text("hrd")),
                      DropdownMenuItem(
                        value: "employee",
                        child: Text("employee"),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  AppGradientButton(
                    text: "Sign Up",
                    onPressed: () {
                      controller.handleRegister();
                    },
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Get.offAllNamed(Routes.login);
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
      ),
    );
  }
}
