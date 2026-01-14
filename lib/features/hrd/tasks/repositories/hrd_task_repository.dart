import 'package:get/get.dart';
import 'package:presentech/shared/models/tasks.dart';
import 'package:presentech/shared/view/components/snackbar/failed_snackbar.dart';
import 'package:presentech/shared/view/components/snackbar/success_snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HrdTaskRepository {
  final SupabaseClient supabase = Supabase.instance.client;
  RxList<Tasks> tasks = <Tasks>[].obs;

  Future<List<Map<String, dynamic>>> fetchTasks() async {
    final response = await supabase
        .from('tasks')
        .select('*, users(name)')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<bool> insertTask(Tasks task) async {
    try {
      await supabase.from('tasks').insert(task.toMap());
      await fetchTasks();
      return true;
    } catch (e) {
      print("Error insertTask: $e");
      FailedSnackbar.show("Gagal menambahkan tugas: ${e.toString()}");
      return false;
    }
  }

  Future<bool> updateTask(Tasks task) async {
    try {
      await supabase.from('tasks').update(task.toMap()).eq('id', task.id!);
      await fetchTasks();
      return true;
    } catch (e) {
      print("Error updateTask: $e");
      FailedSnackbar.show("Gagal memperbarui tugas: ${e.toString()}");
      return false;
    }
  }

  Future<bool> deleteTask(int id) async {
    try {
      await supabase.from('tasks').delete().eq('id', id);
      tasks.removeWhere((t) => t.id == id);
      SuccessSnackbar.show("Tugas berhasil dihapus");
      return true;
    } catch (e) {
      print("Error deleteTask: $e");
      FailedSnackbar.show("Gagal menghapus tugas: ${e.toString()}");
      return false;
    }
  }

  Future<bool> updateTaskStatus(int id, String status) async {
    try {
      await supabase.from('tasks').update({'status': status}).eq('id', id);
      await fetchTasks();
      return true;
    } catch (e) {
      throw ("Error updateTaskStatus: $e");
    }
  }
}
