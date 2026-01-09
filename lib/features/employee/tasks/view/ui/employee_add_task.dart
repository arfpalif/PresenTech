import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/tasks/controller/employee_task_controller.dart';
import 'package:presentech/shared/models/tasks.dart';
import 'package:presentech/shared/view/components/buttons/gradient_btn.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/shared/styles/color_style.dart';

// ignore: must_be_immutable
class EmployeeAddTask extends GetView<EmployeeTaskController> {
  String? selectedLevel;
  String? selectedPriority;

  EmployeeAddTask({super.key});

  void submitForm() async {
    if (controller.titleController.text.isEmpty ||
        controller.acceptanceController.text.isEmpty ||
        controller.dateController.startDateController.text.isEmpty ||
        controller.dateController.endDateController.text.isEmpty ||
        controller.selectedLevel.value == null ||
        controller.selectedPriority.value == null) {
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

    final start = parseDate(controller.dateController.startDateController.text);
    final end = parseDate(controller.dateController.endDateController.text);

    if (start == null || end == null) {
      Get.snackbar("Error", "Format tanggal tidak valid");
      return;
    }

    final newTask = Tasks(
      createdAt: DateTime.now().toIso8601String(),
      acceptanceCriteria: controller.acceptanceController.text,
      startDate: start,
      endDate: end,
      priority: controller.selectedPriority.value!,
      level: controller.selectedLevel.value!,
      title: controller.titleController.text,
      userId: controller.userId!,
    );

    final success = await controller.insertTask(newTask);

    if (success) {
      Get.back();
      Get.snackbar("Success", "Task berhasil ditambahkan");
    } else {
      Get.snackbar("Error", "Gagal menambahkan task");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          "Add Task",
          style: AppTextStyle.heading1.copyWith(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
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
                  _buildLabel('Task Title'),
                  _buildTextField(
                    controller: controller.titleController,
                    hint: 'Enter task title',
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
                  
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Level'),
                            Obx(() => _buildDropdown(
                              value: controller.selectedLevel.value,
                              hint: "Select Level",
                              items: ["easy", "medium", "hard"],
                              onChanged: (val) => controller.selectedLevel.value = val,
                            )),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                       Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Priority'),
                            Obx(() => _buildDropdown(
                              value: controller.selectedPriority.value,
                              hint: "Select Priority",
                              items: ["low", "medium", "high"],
                              onChanged: (val) => controller.selectedPriority.value = val,
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  _buildLabel('Acceptance Criteria'),
                  _buildTextField(
                    controller: controller.acceptanceController,
                    hint: 'Enter details',
                    icon: Icons.check_circle_outline,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            AppGradientButton(
              text: "Create Task",
              onPressed: submitForm,
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
    int maxLines = 1,
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
        maxLines: maxLines,
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
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
     return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: AppTextStyle.normal),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
