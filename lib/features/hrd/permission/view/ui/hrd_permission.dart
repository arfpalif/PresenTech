import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/hrd/permission/controller/hrd_permission_controller.dart';
import 'package:presentech/features/hrd/permission/view/components/filter_change.dart';
import 'package:presentech/features/hrd/permission/view/components/hrd_permission_list.dart';
import 'package:presentech/shared/view/themes/themes.dart';

class HrdPermission extends GetView<HrdPermissionController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HRD Permission Page',
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
        child: Column(
          children: [
            FilterChange(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [SizedBox(height: 10), HrdPermissionList()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
