import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/tasks/controller/date_controller.dart';
import 'package:presentech/features/employee/tasks/controller/employee_task_controller.dart';
import 'package:presentech/features/employee/tasks/model/tasks.dart';
import 'package:presentech/features/views/components/Gradient_btn.dart';
import 'package:presentech/features/views/themes/themes.dart';

class EmployeeAddTask extends StatefulWidget {
  const EmployeeAddTask({super.key});

  @override
  State<EmployeeAddTask> createState() => _EmployeeAddTaskState();
}

class _EmployeeAddTaskState extends State<EmployeeAddTask> {
  final _taskTitleController = TextEditingController();
  final _acceptanceController = TextEditingController();
  final _dateController = Get.put(DateController());
  final _taskController = Get.put(EmployeeTaskController());

  String? selectedLevel;
  String? selectedPriority;

  void submitForm() async {
    if (_acceptanceController.text.isEmpty ||
        _dateController.startDateController.text.isEmpty ||
        _dateController.endDateController.text.isEmpty ||
        selectedLevel == null ||
        selectedPriority == null) {
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

    final newTask = Task(
      createdAt: DateTime.now().toIso8601String(),
      acceptanceCriteria: _acceptanceController.text,
      startDate: start,
      endDate: end,
      priority: selectedPriority!,
      level: selectedLevel!,
      title: _taskTitleController.text,
    );

    final success = await _taskController.insertTask(newTask);

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
      appBar: AppBar(
        title: Text(
          "Tambah tugas",
          style: AppTextStyle.heading1.copyWith(fontSize: 20),
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
                keyboardType: TextInputType.emailAddress,
                controller: _taskTitleController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "Task Title",
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
                            setState(() {
                              selectedLevel = newValue;
                            });
                          },
                          items: [
                            DropdownMenuItem(
                              value: "easy",
                              child: Text("easy"),
                            ),
                            DropdownMenuItem(
                              value: "medium",
                              child: Text("medium"),
                            ),
                            DropdownMenuItem(
                              value: "hard",
                              child: Text("hard"),
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
                            setState(() {
                              selectedPriority = newValue;
                            });
                          },
                          items: [
                            DropdownMenuItem(
                              value: "high",
                              child: Text("high"),
                            ),
                            DropdownMenuItem(
                              value: "medium",
                              child: Text("medium"),
                            ),
                            DropdownMenuItem(value: "low", child: Text("low")),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.text,
                controller: _acceptanceController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "Acceptance criteria",
                  prefixIcon: Icon(Icons.email),
                ),
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
