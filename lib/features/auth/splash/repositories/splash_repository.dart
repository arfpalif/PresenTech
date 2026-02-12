import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:presentech/utils/services/database_service.dart';

class SplashRepository {
  final SupabaseClient supabase = Supabase.instance.client;
  final DatabaseService dbService = DatabaseService.instance;

  Session? getSession() {
    return supabase.auth.currentSession;
  }

  Future<String?> getRole(String userId) async {
    final response = await supabase
        .from('users')
        .select('role')
        .eq('id', userId)
        .single();

    return response['role'] as String?;
  }

  Future<Map<String, dynamic>?> getLocalAuth() async {
    return await dbService.getAuthData();
  }
}
