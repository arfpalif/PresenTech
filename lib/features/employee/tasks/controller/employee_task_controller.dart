import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/shared/models/tasks.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeeTaskController extends GetxController {
  final _supabase = Supabase.instance.client;
  final titleController = TextEditingController();
  final acceptanceController = TextEditingController();
  final userId = Supabase.instance.client.auth.currentUser?.id;

  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final selectedDate = Rx<DateTime?>(null);

  RxList<Tasks> tasks = <Tasks>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  void pickStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      selectedDate.value = picked;
      startDateController.text = "${picked.day}-${picked.month}-${picked.year}";
    }
  }

  void pickEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      selectedDate.value = picked;
      endDateController.text = "${picked.day}-${picked.month}-${picked.year}";
    }
  }

  Future<void> fetchTasks() async {
    try {
      isLoading.value = true;

      final response = await _supabase
          .from('tasks')
          .select()
          .order('id', ascending: false);

      tasks.value = response.map<Tasks>((item) => Tasks.fromMap(item)).toList();
    } catch (e) {
      print("Error fetchTasks: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> insertTask(Tasks task) async {
    try {
      await _supabase.from('tasks').insert(task.toMap());
      await fetchTasks();
      return true;
    } catch (e) {
      print("Error insertTask: $e");
      return false;
    }
  }

  Future<bool> updateTask(Tasks task) async {
    try {
      await _supabase.from('tasks').update(task.toMap()).eq('id', task.id!);
      await fetchTasks();
      return true;
    } catch (e) {
      print("Error insertTask: $e");
      return false;
    }
  }

  Future<bool> deleteTask(int id) async {
    try {
      await _supabase.from('tasks').delete().eq('id', id);
      tasks.removeWhere((t) => t.id == id);
      Get.snackbar("Success", "Task berhasil dihapus");
      return true;
    } catch (e) {
      print("Error deleteTask: $e");
      return false;
    }
  }
}
