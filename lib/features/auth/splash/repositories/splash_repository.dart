import 'package:supabase_flutter/supabase_flutter.dart';

class SplashRepository {
  final SupabaseClient supabase = Supabase.instance.client;

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
}
