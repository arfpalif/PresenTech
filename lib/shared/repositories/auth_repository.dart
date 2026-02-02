import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:presentech/utils/services/database_service.dart';

class AuthRepository {
  final supabase = Supabase.instance.client;
  final dbService = DatabaseService.instance;

  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
      await dbService.clearAuthData();
    } catch (e) {
      throw Exception('Error signing out: $e');
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
    await dbService.saveAuthData(authData);
  }

  Future<Map<String, dynamic>?> getAuthData() async {
    print("AuthRepository: Calling getAuthData");
    return await dbService.getAuthData();
  }
}
