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

  Future<void> updateProfile({required String name, String? imageUrl}) async {
    final userId = supabase.auth.currentUser!.id;
    final Map<String, dynamic> updates = {
      'name': name,
    };
    if (imageUrl != null) {
      updates['profile_picture'] = imageUrl;
    }

    await supabase.from('users').update(updates).eq('id', userId);
  }

  Future<void> updateProfileImage(String imageUrl) async {
    final userId = supabase.auth.currentUser!.id;

    await supabase
        .from('users')
        .update({'profile_picture': imageUrl})
        .eq('id', userId);
  }
}
