import 'package:presentech/constants/api_constant.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HrdPermissionRepository {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchPermissions() async {
    final response = await supabase
        .from('permissions')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> fetchPermissionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final response = await supabase
        .from(ApiConstant.tablePermissions)
        .select()
        .gte('created_at', startDate.toIso8601String())
        .lte('created_at', endDate.toIso8601String())
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> fetchPermissionsByStatus(
    String status,
  ) async {
    final response = await supabase
        .from('permissions')
        .select()
        .eq('status', status)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> approvePermission(int permissionId) async {
    await supabase
        .from('permissions')
        .update({'status': 'approved'})
        .eq('id', permissionId);
  }

  Future<void> rejectPermission(int permissionId, String feedback) async {
    await supabase
        .from('permissions')
        .update({'status': 'rejected', 'feedback': feedback})
        .eq('id', permissionId);
  }
}
