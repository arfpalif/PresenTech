import 'package:supabase_flutter/supabase_flutter.dart';

class HrdEmployeeRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchEmployees() async {
    final response = await supabase
        .from('users')
        .select()
        .order('id', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }
}
