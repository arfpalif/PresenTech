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

class EmployeeTaskDetailController extends GetxController {
  final _taskRepo = TaskRepository();
  final _supabase = Supabase.instance.client;
  String get _userId => _supabase.auth.currentUser?.id ?? "";

  late Tasks task;
  final titleController = TextEditingController();
  final acceptanceController = TextEditingController();
  DateController get dateController => Get.find<DateController>();

  final RxnString selectedLevel = RxnString();
  final RxnString selectedPriority = RxnString();
  final Rxn<TaskStatus> selectedStatus = Rxn<TaskStatus>();
  final RxBool isLoading = false.obs;
  final RxBool isChanged = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args == null) {
      Get.back();
      return;
    }
    task = args as Tasks;

    // Initialize controllers with task data
    titleController.text = task.title;
    acceptanceController.text = task.acceptanceCriteria;
    selectedLevel.value = task.level;
    selectedPriority.value = task.priority;
    selectedStatus.value = task.status ?? TaskStatus.todo;

    // Initialize date controller
    dateController.startDateController.text =
        "${task.startDate.day}-${task.startDate.month}-${task.startDate.year}";
    dateController.endDateController.text =
        "${task.endDate.day}-${task.endDate.month}-${task.endDate.year}";
  }

  Future<void> updateTask() async {
    if (task.id == null) return;

    if (titleController.text.isEmpty ||
        acceptanceController.text.isEmpty ||
        dateController.startDateController.text.isEmpty ||
        dateController.endDateController.text.isEmpty ||
        selectedLevel.value == null ||
        selectedPriority.value == null ||
        selectedStatus.value == null) {
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

    final updatedTask = Tasks(
      id: task.id,
      createdAt: task.createdAt,
      acceptanceCriteria: acceptanceController.text,
      startDate: start,
      endDate: end,
      priority: selectedPriority.value!,
      level: selectedLevel.value!,
      title: titleController.text,
      userId: _userId,
      status: selectedStatus.value,
    );

    try {
      isLoading.value = true;
      await _taskRepo.updateTask(task.id!, updatedTask.toJson());
      isChanged.value = true;
      SuccessDialog.show("Success", "Tugas berhasil diperbarui", () {
        Get.back(result: true);
      });
    } catch (e) {
      debugPrint("Update Task Error: $e");
      FailedSnackbar.show("Gagal memperbarui tugas");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateQuickStatus(TaskStatus status) async {
    if (task.id == null) return;
    try {
      isLoading.value = true;
      selectedStatus.value = status;
      final updatedData = task.toJson();
      updatedData["status"] = status.name;
      await _taskRepo.updateTask(task.id!, updatedData);
      isChanged.value = true;
      SuccessSnackbar.show(
        "Status berhasil diperbarui ke ${status.name.replaceAll('_', ' ')}",
      );
    } catch (e) {
      debugPrint("Update Quick Status Error: $e");
      FailedSnackbar.show("Gagal memperbarui status");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTask(int id) async {
    if (task.id == null) return;

    try {
      isLoading.value = true;
      await _taskRepo.deleteTask(task.id!);
      isChanged.value = true;
      SuccessDialog.show("Sukses", "Tugas berhasil dihapus", () {
        Get.back(result: true);
      });
    } catch (e) {
      debugPrint("Delete Task Error: $e");
      FailedSnackbar.show("Gagal menghapus tugas");
    } finally {
      isLoading.value = false;
    }
  }
}
