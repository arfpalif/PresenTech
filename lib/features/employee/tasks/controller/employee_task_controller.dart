import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/tasks/repositories/task_repository.dart';
import 'package:presentech/shared/controllers/date_controller.dart';
import 'package:presentech/shared/models/tasks.dart';
import 'package:presentech/shared/view/components/dialog/success_dialog.dart';
import 'package:presentech/shared/view/components/snackbar/failed_snackbar.dart';
import 'package:presentech/shared/view/components/snackbar/success_snackbar.dart';
import 'package:presentech/utils/enum/task_status.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeeTaskController extends GetxController {
  // Repository
  final _taskRepo = TaskRepository();

  // Supabase
  final _supabase = Supabase.instance.client;
  String get _userId => _supabase.auth.currentUser?.id ?? "";

  // Controllers
  final titleController = TextEditingController();
  final acceptanceController = TextEditingController();
  DateController get dateController => Get.find<DateController>();

  // Observables
  final selectedLevel = RxnString();
  final selectedPriority = RxnString();
  final tasks = <Tasks>[].obs;
  final isLoading = false.obs;

  // Statistics
  int get totalTasksCount => tasks.length;

  int get todoTasksCount =>
      tasks.where((t) => t.status == TaskStatus.todo).length;

  List<Tasks> get tasksToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return tasks.where((t) {
      final start = DateTime(
        t.startDate.year,
        t.startDate.month,
        t.startDate.day,
      );
      final end = DateTime(t.endDate.year, t.endDate.month, t.endDate.day);
      return !start.isAfter(today) && !end.isBefore(today);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    if (_userId.isEmpty) return;

    try {
      isLoading.value = true;
      final response = await _taskRepo.fetchTasks(_userId);
      tasks.assignAll(response.map((item) => Tasks.fromMap(item)));
    } catch (e) {
      debugPrint("Error fetchTasks: $e");
      FailedSnackbar.show("Gagal mengambil data tugas");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _handleTaskAction(
    Future<void> Function() action,
    String successMsg,
    String errorMsg,
  ) async {
    try {
      isLoading.value = true;
      await action();
      await fetchTasks();
      SuccessSnackbar.show(successMsg);
    } catch (e) {
      debugPrint("Task Action Error: $e");
      FailedSnackbar.show(errorMsg);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> insertTask(Tasks task) async {
    await _taskRepo.insertTask(task.toMap());
  }

  void submitForm() async {
    if (titleController.text.isEmpty ||
        acceptanceController.text.isEmpty ||
        dateController.startDateController.text.isEmpty ||
        dateController.endDateController.text.isEmpty ||
        selectedLevel.value == null ||
        selectedPriority.value == null) {
      FailedSnackbar.show("Harap isi semua field");
      return;
    }

    DateTime? parseDate(String s) {
      try {
        final parts = s.split('-');
        if (parts.length != 3) return null;
        return DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      } catch (_) {
        return null;
      }
    }

    final start = parseDate(dateController.startDateController.text);
    final end = parseDate(dateController.endDateController.text);

    if (start == null || end == null) {
      FailedSnackbar.show("Format tanggal tidak valid");
      return;
    }

    final newTask = Tasks(
      createdAt: DateTime.now().toIso8601String(),
      acceptanceCriteria: acceptanceController.text,
      startDate: start,
      endDate: end,
      priority: selectedPriority.value!,
      level: selectedLevel.value!,
      title: titleController.text,
      userId: _userId,
    );

    await insertTask(newTask);
    await fetchTasks();
    SuccessDialog.show("Success", "Tugas berhasil ditambahkan", () {});
    Get.back();
  }
}
