import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../shared/models/permission.dart';

class PermissionRepository {
  final SupabaseClient supabase = Supabase.instance.client;
  Future<List<Permission>> getPermissions() async {
    try {
      final response = await supabase
          .from('permissions')
          .select()
          .order('created_at', ascending: false);

      return response.map<Permission>((e) => Permission.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Error fetching permissions: $e');
    }
  }

  Future<bool> insertPermission(Permission permission, userId, data) async {
    try {
      await supabase.from('permissions').insert(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> fetchPermissionsByDay(DateTime startDate, DateTime now) async {
    try {
      await supabase
          .from('permissions')
          .select()
          .gte('created_at', startDate.toIso8601String())
          .lte('created_at', now.toIso8601String())
          .order('created_at', ascending: false);
    } catch (e) {
      throw ("Error fetching permissions by day: $e");
    }
  }
}
