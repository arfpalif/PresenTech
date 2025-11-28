import 'package:get/get.dart';
import 'package:presentech/services/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Supabase;

class Logincontroller extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AuthResponse> login(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
}
