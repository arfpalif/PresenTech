import 'package:presentech/shared/models/permission.dart';
import 'package:presentech/utils/enum/permission_status.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PermissionRepository {
  final SupabaseClient supabase = Supabase.instance.client;
  Future<List<Permission>> getPermissions(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
    PermissionStatus? status,
  }) async {
    try {
      var query = supabase.from('permissions').select().eq('user_id', userId);

      if (startDate != null) {
        query = query.gte('created_at', startDate.toIso8601String());
      }
      if (endDate != null) {
        query = query.lte('created_at', endDate.toIso8601String());
      }
      if (status != null) {
        query = query.eq('status', status.name);
      }

      final response = await query.order('created_at', ascending: false);
      return response.map<Permission>((e) => Permission.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Error fetching permissions: $e');
    }
  }

  Future<void> insertPermission(Map<String, dynamic> data) async {
    await supabase.from('permissions').insert(data);
  }

  Future<void> updatePermission(int id, Map<String, dynamic> data) async {
    await supabase.from('permissions').update(data).eq('id', id);
  }
}
