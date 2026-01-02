import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/shared/models/permission.dart';
import 'package:presentech/shared/view/themes/themes.dart';

class EmployeePermissionDetail extends StatelessWidget {
  final Permission permission = Get.arguments as Permission;

  EmployeePermissionDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Permission Detail',
          style: AppTextStyle.title.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[AppColors.colorPrimary, AppColors.greenPrimary],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade100,
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                "${permission.reason}",
                style: AppTextStyle.heading1.copyWith(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              subtitle: Text(
                "Start Date: ${permission.startDate}\n"
                "End Date: ${permission.endDate}\n"
                "Status: ${permission.status}",
                style: AppTextStyle.normal.copyWith(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
