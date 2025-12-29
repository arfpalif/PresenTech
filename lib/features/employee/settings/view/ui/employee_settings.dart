import 'package:flutter/material.dart';
import 'package:presentech/features/employee/settings/view/components/header.dart';
import 'package:presentech/features/employee/settings/view/components/setting_menu.dart';

class EmployeeSettings extends StatelessWidget {
  const EmployeeSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Header(), SizedBox(height: 20), SettingMenu()],
          ),
        ),
      ),
    );
  }
}
