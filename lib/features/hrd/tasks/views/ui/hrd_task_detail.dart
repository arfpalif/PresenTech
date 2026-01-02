import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/hrd/tasks/controller/hrd_task_controller.dart';
import 'package:presentech/shared/models/tasks.dart';
import 'package:presentech/shared/controllers/date_controller.dart';
import 'package:presentech/shared/view/components/Gradient_btn.dart';
import 'package:presentech/shared/view/themes/themes.dart';

// ignore: must_be_immutable
class HrdTaskDetail extends GetView<HrdTaskController> {
  final _taskTitleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _assignedToUserNameController = TextEditingController();
  final DateController _dateController = Get.find<DateController>();

  String? selectedLevel;
  String? selectedPriority;
  String? selectedStatus;

  late final Tasks task;

  HrdTaskDetail({super.key}) {
    task = Get.arguments as Tasks;
    _taskTitleController.text = task.title;
    _descriptionController.text = task.acceptanceCriteria;
    _assignedToUserNameController.text = task.acceptanceCriteria
        .split('Assigned to: ')
        .last;
    _dateController.startDateController.text =
        "${task.startDate.day}-${task.startDate.month}-${task.startDate.year}";
    _dateController.endDateController.text =
        "${task.endDate.day}-${task.endDate.month}-${task.endDate.year}";
    selectedLevel = task.level;
    selectedPriority = task.priority;
  }
  void submitForm() async {
    if (_taskTitleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _dateController.startDateController.text.isEmpty ||
        _dateController.endDateController.text.isEmpty ||
        selectedLevel == null ||
        selectedPriority == null ||
        selectedStatus == null) {
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

    final newTask = Tasks(
      createdAt: task.createdAt,
      startDate: start,
      endDate: end,
      priority: selectedPriority!,
      level: selectedLevel!,
      title: _taskTitleController.text,
      id: task.id,
      acceptanceCriteria:
          '${_descriptionController.text}\nAssigned to: ${_assignedToUserNameController.text}',
      userId: task.userId,
    );

    final success = await controller.updateTask(newTask);

    if (success) {
      Get.back();
      Get.snackbar("Berhasil", "Tugas berhasil diperbarui");
    } else {
      Get.snackbar("Error", "Gagal memperbarui tugas");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Tugas",
          style: AppTextStyle.heading1.copyWith(
            fontSize: 20,
            color: Colors.white,
          ),
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                style: AppTextStyle.normal,
                keyboardType: TextInputType.text,
                controller: _taskTitleController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "Judul Tugas",
                  prefixIcon: Icon(Icons.task_alt),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                style: AppTextStyle.normal,
                readOnly: true,
                controller: _dateController.startDateController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "Tanggal Mulai",
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
                  labelText: "Tanggal Selesai",
                  prefixIcon: Icon(Icons.calendar_month),
                ),
                onTap: () => _dateController.pickEndDate(context),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Level", style: AppTextStyle.heading1),
                        ),
                        DropdownButton<String>(
                          value: selectedLevel,
                          hint: const Text("Level"),
                          isExpanded: true,
                          onChanged: (String? newValue) {
                            selectedLevel = newValue;
                          },
                          items: [
                            DropdownMenuItem(
                              value: "easy",
                              child: Text("Easy"),
                            ),
                            DropdownMenuItem(
                              value: "medium",
                              child: Text("Medium"),
                            ),
                            DropdownMenuItem(
                              value: "hard",
                              child: Text("Hard"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Priority", style: AppTextStyle.heading1),
                        ),
                        DropdownButton<String>(
                          value: selectedPriority,
                          hint: const Text("Priority"),
                          isExpanded: true,
                          onChanged: (String? newValue) {
                            selectedPriority = newValue;
                          },
                          items: [
                            DropdownMenuItem(value: "low", child: Text("Low")),
                            DropdownMenuItem(
                              value: "medium",
                              child: Text("Medium"),
                            ),
                            DropdownMenuItem(
                              value: "high",
                              child: Text("High"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              AppGradientButton(
                text: "Update",
                onPressed: () {
                  submitForm();
                },
              ),
              SizedBox(height: 10),
              AppGradientButtonRed(
                text: "Delete",
                onPressed: () {
                  if (task.id != null) {
                    controller.deleteTask(task.id!);
                    Get.back();
                  } else {
                    Get.snackbar("Error", "ID tugas tidak valid");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
