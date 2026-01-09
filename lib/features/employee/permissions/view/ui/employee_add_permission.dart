import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/permissions/controller/employee_permission_controller.dart';
import 'package:presentech/shared/models/permission.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/shared/view/components/buttons/gradient_btn.dart';
import 'package:presentech/configs/themes/themes.dart';

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
                    color: Colors.grey.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Permission Title'),
                  _buildTextField(
                    controller: controller.permissionTitleController,
                    hint: 'Enter title',
                    icon: Icons.title,
                  ),
                  SizedBox(height: 16),
                  _buildLabel('Duration'),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: controller.dateController.startDateController,
                          hint: 'Start Date',
                          icon: Icons.calendar_today,
                          readOnly: true,
                          onTap: () => controller.dateController.pickStartDate(context),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("to", style: TextStyle(color: Colors.grey)),
                      ),
                      Expanded(
                        child: _buildTextField(
                          controller: controller.dateController.endDateController,
                          hint: 'End Date',
                          icon: Icons.event,
                          readOnly: true,
                          onTap: () => controller.dateController.pickEndDate(context),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildLabel('Type'),
                  Obx(() => _buildDropdown(
                    value: controller.selectedType.value,
                    hint: "Select Type",
                    items: [PermissionType.permission, PermissionType.leave],
                    onChanged: (val) => controller.selectedType.value = val,
                  )),
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: AppTextStyle.normal.copyWith(fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        style: AppTextStyle.normal,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(icon, color: ColorStyle.colorPrimary.withValues(alpha: 0.6), size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required PermissionType? value,
    required String hint,
    required List<PermissionType> items,
    required Function(PermissionType?) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<PermissionType>(
          value: value,
          hint: Text(hint, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          items: items.map((PermissionType item) {
            String label = item == PermissionType.permission ? "Permission" : "Leave";
            return DropdownMenuItem<PermissionType>(
              value: item,
              child: Text(label, style: AppTextStyle.normal),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
