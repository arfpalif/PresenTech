import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  Future<AuthResponse> signUp(String email, String password) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );
    return response;
  }

  Future<String?> getRole(String userId) async {
    final response = await _supabase
        .from('users')
        .select('role')
        .eq('id', userId)
        .single();

    return response['role'] as String?;
  }
}
