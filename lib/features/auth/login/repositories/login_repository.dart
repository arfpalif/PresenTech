import 'package:supabase_flutter/supabase_flutter.dart';

class LoginRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<AuthResponse> login(String email, String password) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
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
