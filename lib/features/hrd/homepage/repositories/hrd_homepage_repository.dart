import 'package:supabase_flutter/supabase_flutter.dart';

class HrdHomepageRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> getUser(String userId) async {
    final response = await _supabase
        .from("users")
        .select('name, profile_picture, role')
        .eq("id", userId)
        .maybeSingle();

    if (response == null) {
      throw Exception("Error");
    }

    return response;
  }
}
