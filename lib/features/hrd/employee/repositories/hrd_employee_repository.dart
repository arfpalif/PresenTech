import 'package:presentech/constants/api_constant.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HrdEmployeeRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchEmployees() async {
    final response = await supabase
        .from(ApiConstant.tableUsers)
        .select()
        .order('id', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> fetchUserAbsences() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found');
    }
    try {
      final response = await supabase
          .from('absences')
          .select()
          .eq('user_id', user.id);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to load absences: $e');
    }
  }
}
