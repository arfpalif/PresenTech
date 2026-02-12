import 'package:drift/drift.dart';
import 'package:get/get.dart' hide Value;
import 'package:presentech/utils/database/database.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:presentech/utils/database/dao/auth_dao.dart';

class AuthRepository {
  final supabase = Supabase.instance.client;
  final _authDao = Get.find<AuthDao>();

  Future<void> signOut() async {
    try {
      await supabase.auth.signOut().catchError((e) {
        print("Supabase remote signout failed: $e");
      });
    } finally {
      await _authDao.clearAuthData();
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      final session = supabase.auth.currentSession;
      if (session == null) return null;
      final user = supabase.auth.currentUser;
      return user;
    } catch (e) {
      throw Exception('Error fetching current user: $e');
    }
  }

  Future<void> saveAuthData(Map<String, dynamic> authData) async {
    print("AuthRepository: Calling saveAuthData for ${authData['email']}");
    await _authDao.saveAuthData(
      AuthTableCompanion(
        id: Value(authData['id']),
        email: Value(authData['email']),
        role: Value(authData['role']),
        lastLogin: Value(authData['last_login']),
      ),
    );
  }

  Future<Map<String, dynamic>?> getAuthData() async {
    print("AuthRepository: Calling getAuthData");
    final data = await _authDao.getAuthData();
    if (data == null) return null;
    return {
      'id': data.id,
      'email': data.email,
      'role': data.role,
      'last_login': data.lastLogin,
    };
  }
}
