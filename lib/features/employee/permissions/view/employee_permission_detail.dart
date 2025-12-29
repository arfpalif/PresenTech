import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/hrd/permission/controller/hrd_permission_controller.dart';
import 'package:presentech/shared/view/themes/themes.dart';

class EmployeePermissionDetail extends GetView<HrdPermissionController> {
  final permission = Get.arguments;

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
              colors: <Color>[AppColors.colorPrimary, AppColors.colorSecondary],
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
