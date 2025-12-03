import 'package:flutter/material.dart';
import 'package:presentech/views/themes/themes.dart';

class EmployeeReports extends StatefulWidget {
  const EmployeeReports({super.key});

  @override
  State<EmployeeReports> createState() => _EmployeeReportsState();
}

class _EmployeeReportsState extends State<EmployeeReports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Ini halaman reports", style: AppTextStyle.heading1,)
          ],
        ),
      ),
    );
  }
}