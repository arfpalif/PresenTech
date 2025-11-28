import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:presentech/controller/loginController.dart';
import 'package:presentech/views/themes/themes.dart';

class Loginpages extends StatefulWidget {
  const Loginpages({super.key});

  @override
  State<Loginpages> createState() => _LoginpagesState();
}

class _LoginpagesState extends State<Loginpages> {
  final _emailController = TextEditingController();
  final _passWordController = TextEditingController();
  final _nameController = TextEditingController();
  final controller = Get.find<Logincontroller>();
  String? selectedValue = 'One';

  List<String> options = ['HRD', 'employee'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SvgPicture.asset("src/images/ic_signup.svg"),
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              obscureText: false,
              decoration: InputDecoration(
                labelText: "email",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
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
                border: OutlineInputBorder(),
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
                border: OutlineInputBorder(),
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
                controller.login(_emailController.text, _passWordController.text);
              },
              child: Text(
                "Sign Up",
                style: AppTextStyle.normal.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
