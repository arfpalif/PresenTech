import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/permissions/controller/employee_permission_controller.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/shared/view/components/buttons/gradient_btn.dart';
import 'package:presentech/shared/view/components/dropdowns/dropdown_field_normal.dart';
import 'package:presentech/shared/view/components/textFields/text_field_normal.dart';
import 'package:presentech/shared/styles/input_style.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/utils/enum/permission_type.dart';

class EmployeeAddPermission extends GetView<EmployeePermissionController> {
  const EmployeeAddPermission({super.key, this.isEdit = false});
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          'Add Permission',
          style: AppTextStyle.title.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
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
              colors: <Color>[ColorStyle.colorPrimary, ColorStyle.greenPrimary],
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Permission Title',
                    style: AppTextStyle.normal.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFieldNormal(
                    controller: controller.permissionTitleController,
                    decoration: AppInputStyle.decoration(icon: Icons.title),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Duration',
                    style: AppTextStyle.normal.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFieldNormal(
                          controller:
                              controller.dateController.startDateController,
                          readOnly: true,
                          onTap: () =>
                              controller.dateController.pickStartDate(context),
                          decoration: AppInputStyle.decoration(
                            icon: Icons.calendar_today,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("to", style: TextStyle(color: Colors.grey)),
                      ),
                      Expanded(
                        child: TextFieldNormal(
                          controller:
                              controller.dateController.endDateController,
                          readOnly: true,
                          onTap: () =>
                              controller.dateController.pickEndDate(context),
                          decoration: AppInputStyle.decoration(
                            icon: Icons.event,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Type',
                    style: AppTextStyle.normal.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => DropdownFieldNormal<PermissionType>(
                      value: controller.selectedType.value,
                      items: const [
                        PermissionType.permission,
                        PermissionType.leave,
                      ],
                      labelBuilder: (type) => type == PermissionType.permission
                          ? "Permission"
                          : "Leave",
                      onChanged: (val) => controller.selectedType.value = val,
                      decoration: AppInputStyle.decoration(
                        icon: Icons.category,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            AppGradientButton(
              text: "Submit Request",
              onPressed: () {
                controller.submitForm();
              },
            ),
          ],
        ),
      ),
    );
  }
}
