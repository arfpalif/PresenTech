import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/tasks/model/tasks.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeeTaskController extends GetxController {
  final _supabase = Supabase.instance.client;
  final titleController = TextEditingController();
  final acceptanceController = TextEditingController();

  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final selectedDate = Rx<DateTime?>(null);

  RxList<Task> tasks = <Task>[].obs;
  RxBool isLoading = false.obs;

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

      final response = await _supabase
          .from('tasks')
          .select()
          .order('id', ascending: false);

      tasks.value = response
          .map<Task>((item) => Task.fromJson(item))
          .toList();
      
    } catch (e) {
      print("Error fetchTasks: $e");
    } finally {
    }
  }

  Future<bool> insertTask(Task task) async {
    try {
      await _supabase.from('tasks').insert(task.toInsertJson());
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
      return true;
    } catch (e) {
      print("Error deleteTask: $e");
      return false;
    }
  }
}
