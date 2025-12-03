import 'package:flutter/material.dart';

class EmployeePermission extends StatefulWidget {
  const EmployeePermission({super.key});

  @override
  State<EmployeePermission> createState() => _EmployeePermissionState();
}

class _EmployeePermissionState extends State<EmployeePermission> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Halaman permission")
          ],
        ),
      ),
    );
  }
}