import 'package:flutter/material.dart';

class EmployeeTask extends StatefulWidget {
  const EmployeeTask({super.key});

  @override
  State<EmployeeTask> createState() => _EmployeeTaskState();
}

class _EmployeeTaskState extends State<EmployeeTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Halaman task")
          ],
        ),
      ),
    );
  }
}