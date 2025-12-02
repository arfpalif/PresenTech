import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:presentech/controller/auth_controller.dart';
import 'package:presentech/controller/auth_gate.dart';
import 'package:presentech/views/pages/register_pages.dart';
import 'package:presentech/views/themes/themes.dart';

class Loginpages extends StatefulWidget {
  const Loginpages({super.key});

  @override
  State<Loginpages> createState() => _LoginpagesState();
}

class _LoginpagesState extends State<Loginpages> {
  final _authController = Get.put(AuthController());
  final _emailController = TextEditingController();
  final _passWordController = TextEditingController();
  final _nameController = TextEditingController();
  String? selectedValue = 'One';

  List<String> options = ['HRD', 'employee'];
  void login() async {
    final email = _emailController.text;
    final password = _passWordController.text;
    try {
      final res = await _authController.login(email, password);
      if (res.session != null || res.user != null) {
        Get.offAll(const AuthGate());
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Login gagal")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("src/images/ic_signup.svg"),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Email", style: AppTextStyle.normal),
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                obscureText: false,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
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
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.password),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      5,
                    ), // Adjust the value for desired roundness
                  ),
                  backgroundColor: AppColors.colorSecondary,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  login();
                },
                child: Text(
                  "Sign Up",
                  style: AppTextStyle.normal.copyWith(color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              new GestureDetector(
                onTap: () {
                  Get.offAll(RegisterPages());
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
    );
  }
}
