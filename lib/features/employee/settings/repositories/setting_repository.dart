import 'package:supabase_flutter/supabase_flutter.dart';

class SettingRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      final response = await supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      return response;
    } catch (e) {
      throw Exception('Error fetching user profile: $e');
    }
  }
}
