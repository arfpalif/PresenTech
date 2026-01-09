import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/hrd/permission/controller/hrd_permission_controller.dart';
import 'package:presentech/features/hrd/permission/view/components/filter_change.dart';
import 'package:presentech/features/hrd/permission/view/components/hrd_permission_list.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/shared/styles/color_style.dart';

class HrdPermission extends GetView<HrdPermissionController> {
  const HrdPermission({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          'Permissions',
          style: AppTextStyle.title.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                ColorStyle.colorPrimary,
                ColorStyle.greenPrimary,
              ],
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            FilterChange(),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [HrdPermissionList()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
