import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
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

  Future<void> updateProfileImage(String imageUrl) async {
    final userId = supabase.auth.currentUser!.id;

    await supabase
        .from('users')
        .update({'profile_picture': imageUrl})
        .eq('id', userId);
  }
}
