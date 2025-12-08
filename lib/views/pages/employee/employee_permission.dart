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
      appBar: AppBar(
        title: Text("Halaman permission"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Halaman permission")
            ],
          ),
        ),
      ),
    );
  }
}