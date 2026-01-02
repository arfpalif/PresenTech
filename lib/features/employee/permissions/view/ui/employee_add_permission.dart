import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/permissions/controller/employee_permission_controller.dart';
import 'package:presentech/shared/models/permission.dart';
import 'package:presentech/shared/controllers/date_controller.dart';
import 'package:presentech/shared/view/components/Gradient_btn.dart';
import 'package:presentech/shared/view/themes/themes.dart';

class EmployeeAddPermission extends GetView<EmployeePermissionController> {
  final _PermissionTitleController = TextEditingController();
  final _dateController = Get.find<DateController>();
  final _PermissionController = Get.find<EmployeePermissionController>();

  final Rx<PermissionType?> selectedType = Rx<PermissionType?>(null);

  final bool isEdit;

  EmployeeAddPermission({super.key, this.isEdit = false});

  void submitForm() async {
    if (_PermissionTitleController.text.isEmpty ||
        _dateController.startDateController.text.isEmpty ||
        _dateController.endDateController.text.isEmpty ||
        selectedType.value == null) {
      Get.snackbar("Error", "Harap isi semua field");
      return;
    }

    DateTime? parseDate(String s) {
      try {
        final parts = s.split('-');
        if (parts.length != 3) return null;
        final d = int.parse(parts[0]);
        final m = int.parse(parts[1]);
        final y = int.parse(parts[2]);
        return DateTime(y, m, d);
      } catch (_) {
        return null;
      }
    }

    final start = parseDate(_dateController.startDateController.text);
    final end = parseDate(_dateController.endDateController.text);

    if (start == null || end == null) {
      Get.snackbar("Error", "Format tanggal tidak valid");
      return;
    }

    final newPermission = Permission(
      createdAt: DateTime.now(),
      startDate: start,
      endDate: end,
      type: selectedType.value!,
      reason: _PermissionTitleController.text,
    );

    final success = await _PermissionController.insertPermission(newPermission);

    if (success) {
      await _PermissionController.getPermission();
      Get.back();
      Get.snackbar("Success", "Permission berhasil ditambahkan");
    } else {
      Get.snackbar("Error", "Gagal menambahkan Permission");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Permission',
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.colorSecondary,
        foregroundColor: Colors.white,
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                style: AppTextStyle.normal,
                keyboardType: TextInputType.emailAddress,
                controller: _PermissionTitleController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "Permission Title",
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                style: AppTextStyle.normal,
                readOnly: true,
                controller: _dateController.startDateController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "Start Date",
                  prefixIcon: Icon(Icons.calendar_month),
                ),
                onTap: () => _dateController.pickStartDate(context),
              ),
              SizedBox(height: 10),
              TextField(
                style: AppTextStyle.normal,
                readOnly: true,
                controller: _dateController.endDateController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "End Date",
                  prefixIcon: Icon(Icons.calendar_month),
                ),
                onTap: () => _dateController.pickEndDate(context),
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Type", style: AppTextStyle.heading1),
                  ),
                  DropdownButton<PermissionType>(
                    value: selectedType.value,
                    hint: const Text("Type"),
                    isExpanded: true,
                    onChanged: (PermissionType? newValue) {
                      selectedType.value = newValue;
                    },
                    items: [
                      const DropdownMenuItem(
                        value: PermissionType.permission,
                        child: Text("Permission"),
                      ),
                      const DropdownMenuItem(
                        value: PermissionType.leave,
                        child: Text("Leave"),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              AppGradientButton(
                text: "Submit",
                onPressed: () {
                  submitForm();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
