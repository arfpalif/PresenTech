import 'package:flutter/material.dart';

class EmployeeReports extends StatelessWidget {
  const EmployeeReports({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: const Center(child: Text('Employee Reports')),
    );
  }
}
