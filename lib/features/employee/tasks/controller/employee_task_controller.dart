import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/tasks/repositories/task_repository.dart';
import 'package:presentech/shared/controllers/date_controller.dart';
import 'package:presentech/shared/models/tasks.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeeTaskController extends GetxController {
  //repository
  final taskRepo = TaskRepository();

  //controllers
  final titleController = TextEditingController();
  final acceptanceController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final RxnString selectedLevel = RxnString();
  final RxnString selectedPriority = RxnString();
  late final DateController dateController;

  //supabase client
  final userId = Supabase.instance.client.auth.currentUser?.id;

  final selectedDate = Rx<DateTime?>(null);

  RxList<Tasks> tasks = <Tasks>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
    dateController = Get.find<DateController>();
  }

  Future<void> fetchTasks() async {
    try {
      isLoading.value = true;

      final response = await taskRepo.fetchTasks();
      tasks.value = response.map<Tasks>((item) => Tasks.fromMap(item)).toList();
    } catch (e) {
      print("Error fetchTasks: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> insertTask(Tasks task) async {
    try {
      await taskRepo.insertTask(task);
      await fetchTasks();
      return true;
    } catch (e) {
      print("Error insertTask: $e");
      return false;
    }
  }

  Future<bool> updateTask(Tasks task) async {
    try {
      await taskRepo.updateTask(task);
      await fetchTasks();
      return true;
    } catch (e) {
      print("Error insertTask: $e");
      return false;
    }
  }

  Future<bool> deleteTask(int id) async {
    try {
      await taskRepo.deleteTask(id);
      tasks.removeWhere((t) => t.id == id);
      Get.snackbar("Success", "Task berhasil dihapus");
      return true;
    } catch (e) {
      print("Error deleteTask: $e");
      return false;
    }
  }
}
