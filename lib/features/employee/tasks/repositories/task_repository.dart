import 'package:presentech/constants/api_constant.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TaskRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<PostgrestList> fetchTasks() async {
    try {
      final response = await supabase
          .from(ApiConstant.tableTasks)
          .select()
          .order('id', ascending: false);
      return response;
    } catch (e) {
      throw Exception('Error fetching tasks: $e');
    }
  }

  Future<bool> insertTask(task) async {
    try {
      await supabase.from('tasks').insert(task.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateTask(task) async {
    try {
      await supabase.from('tasks').update(task.toMap()).eq('id', task.id!);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteTask(int id) async {
    try {
      await supabase.from('tasks').delete().eq('id', id);
      return true;
    } catch (e) {
      print("Error deleteTask: $e");
      return false;
    }
  }
}
