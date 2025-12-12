import 'package:flutter/material.dart';

class EmployeeTaskDetail extends StatefulWidget {
  const EmployeeTaskDetail({super.key});

  @override
  State<EmployeeTaskDetail> createState() => _EmployeeTaskDetailState();
}

class _EmployeeTaskDetailState extends State<EmployeeTaskDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text("Employee task"),
    );
  }
}