import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final SupabaseClient _Supabase = Supabase.instance.client;

  var isLoading = true.obs;
  var role = ''.obs;

  @override
  void onInit() {
    super.onInit();
    handleAuthState();
  }

  void handleAuthState() {
    final supa = Supabase.instance.client;

    supa.auth.onAuthStateChange.listen((data) async {
      final session = supa.auth.currentSession;

      if (session == null) {
        isLoading.value = false;
        role.value = 'none';
        return;
      }

      isLoading.value = true;
      final userId = session.user.id;

      final result = await supa
          .from('users')
          .select('role')
          .eq('id', userId)
          .single();

      role.value = result['role'];
      isLoading.value = false;
    });
  }

  Future<AuthResponse> login(String email, String password) async {
    final response = await _Supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response;
  }

  Future<AuthResponse> signUp(String email, String password) async {
    final response = await _Supabase.auth.signUp(
      email: email,
      password: password,
    );
    return response;
  }

  Future<AuthResponse?> signUpWithRole(
    String email,
    String password,
    String? role,
  ) async {
    try {
      final response = await signUp(email, password);
      final user = response.user;

      if (user != null && role != null && role.isNotEmpty) {
        await _Supabase.from('users').upsert({
          'id': user.id,
          'email': email,
          'role': role,
          'created_at': DateTime.now().toIso8601String(),
        });
      }
      return response;
    } catch (e) {
      print('Error in signUpWithRole: $e');
      return null;
    }
  }

  void handleRegister() async {}

  Future<bool> checkEmail(String email) async {
    final response = await _Supabase.from(
      'users',
    ).select().eq('email', email).maybeSingle();
    return response == null;
  }

  Session? getCurrentSession() {
    return _Supabase.auth.currentSession;
  }

  bool isLoggedIn() {
    return _Supabase.auth.currentSession != null;
  }

  String? getUserEmail() {
    final session = _Supabase.auth.currentSession;
    final email = session?.user.email;
    return email;
  }

  Future<void> signOut() async {
    isLoading.value = true;
    role.value = 'none';
    await _Supabase.auth.signOut();
    isLoading.value = false;
  }
}
