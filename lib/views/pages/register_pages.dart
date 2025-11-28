import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:presentech/views/themes/themes.dart';

class RegisterPages extends StatefulWidget {
  const RegisterPages({super.key});

  @override
  State<RegisterPages> createState() => _RegisterPagesState();
}

class _RegisterPagesState extends State<RegisterPages> {
  final _emailController = TextEditingController();
  final _passWordController = TextEditingController();
  final _nameController = TextEditingController();
  String? selectedValue;

  List<String> options = ['HRD', 'employee'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("src/images/ic_signup.svg"),
              SizedBox(height: 20),
              Text("Daftar Akun", style: AppTextStyle.heading1),
              SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                keyboardType: TextInputType.text,
                controller: _passWordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "password",
                  prefixIcon: Icon(Icons.password),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(width: 0.1),
                  ),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                keyboardType: TextInputType.text,
                controller: _nameController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "name",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(width: 0.1),
                  ),
                ),
              ),
              SizedBox(height: 30),
              // DropdownButton<String>(
              //   value: selectedValue,
              //   icon: const Icon(Icons.arrow_downward),
              //   elevation: 16,
              //   style: const TextStyle(color: Colors.deepPurple),
              //   underline: Container(
              //     // Hides or customizes the default underline
              //     height: 2,
              //     color: Colors.deepPurpleAccent,
              //   ),
              //   onChanged: (String? newValue) {
              //     // This is called when the user selects an item.
              //     setState(() {
              //       selectedValue = newValue;
              //     });
              //   },
              //   items: options.map<DropdownMenuItem<String>>((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(value),
              //     );
              //   }).toList(),
              // ),
              Text("Select role", style: AppTextStyle.normal,),
              DropdownButton<String>(
                value: selectedValue,
                hint: const Text("Pilih Role"),
                isExpanded: true, // biar full width
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue;
                  });
                },
                items: options.map((role) {
                  return DropdownMenuItem(value: role, child: Text(role));
                }).toList(),
              ),
              SizedBox(height: 10,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      5,
                    ), // Adjust {the value for desired roundness
                  ),
                  backgroundColor: AppColors.colorSecondary,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {},
                child: Text(
                  "Sign Up",
                  style: AppTextStyle.normal.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
