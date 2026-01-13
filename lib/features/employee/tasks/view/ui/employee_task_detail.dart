import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/tasks/controller/employee_task_controller.dart';
import 'package:presentech/shared/controllers/date_controller.dart';
import 'package:presentech/shared/models/tasks.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/shared/view/components/buttons/gradient_btn.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/shared/view/components/snackbar/failed_snackbar.dart';
import 'package:presentech/shared/view/components/snackbar/success_snackbar.dart';
import 'package:presentech/shared/view/components/textFields/text_field_outlined.dart';

// ignore: must_be_immutable
class EmployeeTaskDetail extends GetView<EmployeeTaskController> {
  final _taskTitleController = TextEditingController();
  final _acceptanceController = TextEditingController();
  final _dateController = Get.find<DateController>();

  String? selectedLevel;
  String? selectedPriority;

  late final Tasks task;
  EmployeeTaskDetail({super.key}) {
    task = Get.arguments as Tasks;
    _taskTitleController.text = task.title;
    _acceptanceController.text = task.acceptanceCriteria;
    _dateController.startDateController.text =
        "${task.startDate.day}-${task.startDate.month}-${task.startDate.year}";
    _dateController.endDateController.text =
        "${task.endDate.day}-${task.endDate.month}-${task.endDate.year}";
    selectedLevel = task.level;
    selectedPriority = task.priority;
  }

  void submitForm() async {
    if (_acceptanceController.text.isEmpty ||
        _dateController.startDateController.text.isEmpty ||
        _dateController.endDateController.text.isEmpty ||
        selectedLevel == null ||
        selectedPriority == null) {
      FailedSnackbar.show("Harap isi semua field");
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
      FailedSnackbar.show("Format tanggal tidak valid");
      return;
    }

    final newTask = Tasks(
      createdAt: task.createdAt,
      acceptanceCriteria: _acceptanceController.text,
      startDate: start,
      endDate: end,
      priority: selectedPriority!,
      level: selectedLevel!,
      title: _taskTitleController.text,
      id: task.id,
      userId: task.userId,
    );
    await controller.updateTask(newTask);
    SuccessSnackbar.show("Tugas berhasil diperbarui");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          "Detail Tasks",
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
        physics: const BouncingScrollPhysics(),
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
                  _buildLabel('Task Title'),
                  TextFieldOutlined(
                    controller: _taskTitleController,
                    decoration: _inputDecoration(
                      hint: "Enter task title",
                      icon: Icons.title,
                    ),
                    icon: Icon(Icons.title), // keeping for compatibility
                  ),
                  SizedBox(height: 16),

                  _buildLabel('Dates'),
                  Row(
                    children: [
                      Expanded(
                        child: TextFieldOutlined(
                          readOnly: true,
                          controller: _dateController.startDateController,
                          decoration: _inputDecoration(
                            hint: "Start",
                            icon: Icons.calendar_today,
                          ),
                          icon: Icon(Icons.calendar_today),
                          onTap: () => _dateController.pickStartDate(context),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: TextFieldOutlined(
                          readOnly: true,
                          controller: _dateController.endDateController,
                          decoration: _inputDecoration(
                            hint: "End",
                            icon: Icons.event,
                          ),
                          icon: Icon(Icons.event),
                          onTap: () => _dateController.pickEndDate(context),
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
                            StatefulBuilder(
                              builder: (context, setState) => Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedLevel,
                                    hint: Text("Select Level"),
                                    isExpanded: true,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.grey,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedLevel = newValue;
                                      });
                                    },
                                    items: ["easy", "medium", "hard"].map((
                                      String value,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Priority'),
                            StatefulBuilder(
                              builder: (context, setState) => Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedPriority,
                                    hint: Text("Select Priority"),
                                    isExpanded: true,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.grey,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedPriority = newValue;
                                      });
                                    },
                                    items: ["high", "medium", "low"].map((
                                      String value,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  _buildLabel('Acceptance Criteria'),
                  TextFieldOutlined(
                    controller: _acceptanceController,
                    decoration: _inputDecoration(
                      hint: "Enter criteria",
                      icon: Icons.checklist_rtl,
                    ),
                    icon: Icon(Icons.checklist),
                  ),
                  SizedBox(height: 30),

                  AppGradientButton(
                    text: "Update Task",
                    onPressed: () {
                      submitForm();
                    },
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        foregroundColor: Colors.red,
                      ),
                      onPressed: () {
                        controller.deleteTask(task.id!);
                        Get.back();
                      },
                      child: Text(
                        "Delete Task",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(
        label,
        style: AppTextStyle.normal.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: ColorStyle.colorPrimary),
      ),
    );
  }
}
