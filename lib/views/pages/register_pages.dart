import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:presentech/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:presentech/views/components/Gradient_btn.dart';
import 'package:presentech/views/pages/employee/employee_homepage.dart';
import 'package:presentech/views/pages/hrd/hrd_homepage.dart';
import 'package:presentech/views/pages/loginpage.dart';
import 'package:presentech/views/themes/themes.dart';

class RegisterPages extends StatefulWidget {
  const RegisterPages({super.key});

  @override
  State<RegisterPages> createState() => _RegisterPagesState();
}

class _RegisterPagesState extends State<RegisterPages> {
  final _authController = AuthController();
  final _emailController = TextEditingController();
  final _passWordController = TextEditingController();
  final _nameController = TextEditingController();
  String? selectedValue;

  List<String> options = ['hrd', 'employee'];

  void register() async {
    final email = _emailController.text.trim();
    final password = _passWordController.text.trim();
    final name = _nameController.text.trim();
    final role = selectedValue;

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Semua field harus diisi")));
      return;
    }

    if (role == null || role.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Pilih role terlebih dahulu")));
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final available = await _authController.checkEmail(email);
      if (!available) {
        if (Navigator.canPop(context)) Navigator.of(context).pop();
        Get.snackbar("Error", "Email sudah terdaftar");
        return;
      }

      final res = await _authController.signUpWithRole(email, password, role);
      if (Navigator.canPop(context)) Navigator.of(context).pop();

      if (res != null && res.user != null) {
        if(role == 'hrd'){
          Get.offAll(const HrdHomepage());
        }
        else{
          Get.offAll(const EmployeeHomepage());
        }
        
      } else {
        Get.snackbar("Gagal register", "Gagal registrasi");
      }
    } catch (e) {
      if (Navigator.canPop(context)) Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error $e")));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.00),
          child: SingleChildScrollView(
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
                  Text("Daftar Akun", style: AppTextStyle.heading1,),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Email",
                      style: AppTextStyle.normal,
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    obscureText: false,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      
                    ),
                  ),
                  SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Password",
                      style: AppTextStyle.normal,
                    ),
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
                    child: Text(
                      "Nama",
                      style: AppTextStyle.normal,
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _nameController,
                    obscureText: false,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      
                    ),
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
                      setState(() {
                        selectedValue = newValue;
                      });
                    },
                    items: [
                      DropdownMenuItem(value: "hrd", child: Text("hrd")),
                      DropdownMenuItem(value: "employee", child: Text("employee")),
                    ],
                  ),
                  SizedBox(height: 10,),
                  AppGradientButton(
                    text: "Sign Up",
                    onPressed: () {
                      register();
                    },
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      Get.offAll(Loginpage());
                    },
                    child: Text("Sudah memiliki akun ? Login", style: AppTextStyle.normal.copyWith(fontSize: 12),),
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
