import 'package:presentech/constants/api_constant.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TaskRemoteDataSource {
  final SupabaseClient _supabase;

  TaskRemoteDataSource({SupabaseClient? supabaseClient})
    : _supabase = supabaseClient ?? Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchTasks(String userId) async {
    final response = await _supabase
        .from(ApiConstant.tableTasks)
        .select()
        .eq('user_id', userId)
        .order('id', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> insertTask(Map<String, dynamic> data) async {
    final response = await _supabase
        .from(ApiConstant.tableTasks)
        .insert(data)
        .select()
        .single();

    return Map<String, dynamic>.from(response);
  }

  Future<void> updateTask(int id, Map<String, dynamic> data) async {
    await _supabase.from(ApiConstant.tableTasks).update(data).eq('id', id);
  }

  Future<void> deleteTask(int id) async {
    await _supabase.from(ApiConstant.tableTasks).delete().eq('id', id);
  }
}
