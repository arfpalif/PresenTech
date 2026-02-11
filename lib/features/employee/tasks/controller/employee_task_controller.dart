import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/tasks/repositories/task_repository.dart';
import 'package:presentech/shared/controllers/date_controller.dart';
import 'package:presentech/shared/models/tasks.dart';
import 'package:presentech/shared/view/components/dialog/success_dialog.dart';
import 'package:presentech/shared/view/components/snackbar/failed_snackbar.dart';
import 'package:presentech/utils/enum/task_status.dart';
import 'package:presentech/utils/services/connectivity_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeeTaskController extends GetxController {
  // Repository
  final _taskRepo = TaskRepository();

  // Supabase
  final _supabase = Supabase.instance.client;
  String get _userId => _supabase.auth.currentUser?.id ?? "";

  final connectivityService = Get.find<ConnectivityService>();

  final titleController = TextEditingController();
  final acceptanceController = TextEditingController();
  DateController get dateController => Get.find<DateController>();

  final selectedLevel = RxnString();
  final selectedPriority = RxnString();
  final tasks = <Tasks>[].obs;
  final isLoading = false.obs;

  int get totalTasksCount => tasks.length;

  int get overdueTasksCount => tasks.where((t) => isTaskOverdue(t)).length;
  int get completedTasksCount =>
      tasks.where((t) => t.status == TaskStatus.finished).length;
  int get inProgressTasksCount =>
      tasks.where((t) => t.status == TaskStatus.on_progress).length;
  int get toDoProgressTasksCount =>
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

  bool isTaskOverdue(Tasks task) {
    if (task.status == TaskStatus.finished) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final deadlineDay = DateTime(
      task.endDate.year,
      task.endDate.month,
      task.endDate.day,
    );
    return today.isAfter(deadlineDay);
  }

  @override
  void onInit() {
    super.onInit();
    fetchTasks();

    ever(connectivityService.isOnline, (bool isOnline) {
      if (isOnline) {
        _taskRepo.syncOfflineTasks();
      }
    });
  }

  Future<void> fetchTasks() async {
    if (_userId.isEmpty) return;

    try {
      isLoading.value = true;
      final response = await _taskRepo.fetchTasks(_userId);
      tasks.assignAll(response);
    } catch (e) {
      debugPrint("Error fetchTasks: $e");
      FailedSnackbar.show("Gagal mengambil data tugas");
    } finally {
      isLoading.value = false;
    }
  }

  Future<int?> insertTask(Tasks task) async {
    return await _taskRepo.insertTask(task.toJson());
  }

  Future<void> deleteTask(int id) async {
    try {
      tasks.removeWhere((t) => t.id == id);

      _taskRepo.deleteTask(id).catchError((e) {
        debugPrint("Background Delete Error: $e");
        fetchTasks();
      });
    } catch (e) {
      debugPrint("Error deleteTask: $e");
      FailedSnackbar.show("Gagal menghapus tugas");
    }
  }

  void onTaskUpdated(Tasks updatedTask) {
    final index = tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask;
      tasks.refresh();
    }
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

    if (start.isAfter(end)) {
      FailedSnackbar.show(
        "Tanggal mulai tidak boleh lebih lama dari tanggal selesai",
      );
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

    try {
      tasks.insert(0, newTask);

      insertTask(newTask)
          .then((id) {
            if (id != null) {
              newTask.id = id;
              tasks.refresh();
              print("Optimistic ID Updated: $id");
            }
          })
          .catchError((e) {
            debugPrint("Background Insert Error: $e");
            fetchTasks();
          });

      SuccessDialog.show("Success", "Tugas berhasil ditambahkan", () {
        Get.back();
      });
    } catch (e) {
      debugPrint("Insert Task Error: $e");
      FailedSnackbar.show("Gagal menambahkan tugas");
      return;
    }
  }
}
