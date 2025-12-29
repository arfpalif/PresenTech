import 'package:get/get.dart';
import 'package:presentech/shared/models/tasks.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HrdTaskController extends GetxController {
  final _supabase = Supabase.instance.client;

  RxList<Tasks> tasks = <Tasks>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    try {
      isLoading.value = true;

      final response = await _supabase
          .from('tasks')
          .select('*, users!tasks_user_id_fkey(name)')
          .order('id', ascending: false);

      tasks.value = response.map<Tasks>((item) => Tasks.fromMap(item)).toList();
    } catch (e) {
      print("Error fetchTasks: $e");
      Get.snackbar("Error", "Gagal mengambil data tugas: ${e.toString()}");
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
      Get.snackbar("Error", "Gagal menambahkan tugas: ${e.toString()}");
      return false;
    }
  }

  Future<bool> updateTask(Tasks task) async {
    try {
      await _supabase.from('tasks').update(task.toMap()).eq('id', task.id!);
      await fetchTasks();
      return true;
    } catch (e) {
      print("Error updateTask: $e");
      Get.snackbar("Error", "Gagal memperbarui tugas: ${e.toString()}");
      return false;
    }
  }

  Future<bool> deleteTask(int id) async {
    try {
      await _supabase.from('tasks').delete().eq('id', id);
      tasks.removeWhere((t) => t.id == id);
      Get.snackbar("Berhasil", "Tugas berhasil dihapus");
      return true;
    } catch (e) {
      print("Error deleteTask: $e");
      Get.snackbar("Error", "Gagal menghapus tugas: ${e.toString()}");
      return false;
    }
  }

  Future<bool> updateTaskStatus(int id, String status) async {
    try {
      await _supabase.from('tasks').update({'status': status}).eq('id', id);
      await fetchTasks();
      return true;
    } catch (e) {
      print("Error updateTaskStatus: $e");
      return false;
    }
  }
}
