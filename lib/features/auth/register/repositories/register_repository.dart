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

  Future<AuthResponse?> signUpWithRole(
    String email,
    String password,
    String? role,
    String? name,
  ) async {
    try {
      final response = await signUp(email, password);
      final user = response.user;

      if (user != null && role != null && role.isNotEmpty) {
        await _supabase.from('users').upsert({
          'id': user.id,
          'email': email,
          'role': role,
          'name': name,
          'created_at': DateTime.now().toIso8601String(),
        });
      }
      return response;
    } catch (e) {
      throw ('Error in signUpWithRole: $e');
    }
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
