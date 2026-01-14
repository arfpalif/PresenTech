import 'package:presentech/constants/api_constant.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TaskRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchTasks(String userId) async {
    final response = await supabase
        .from(ApiConstant.tableTasks)
        .select()
        .eq('user_id', userId)
        .order('id', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> insertTask(Map<String, dynamic> data) async {
    await supabase.from(ApiConstant.tableTasks).insert(data);
  }

  Future<void> updateTask(int id, Map<String, dynamic> data) async {
    await supabase.from(ApiConstant.tableTasks).update(data).eq('id', id);
  }

  Future<void> deleteTask(int id) async {
    await supabase.from(ApiConstant.tableTasks).delete().eq('id', id);
  }
}
