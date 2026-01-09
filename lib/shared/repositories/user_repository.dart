import 'package:presentech/constants/api_constant.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {
      final response = await supabase
          .from(ApiConstant.tableUsers)
          .select()
          .eq('id', userId)
          .single();

      return response as Map<String, dynamic>?;
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

  Future<Map<String, dynamic>?> getUser() async {
    try {
      final response = await supabase
          .from(ApiConstant.tableUsers)
          .select()
          .single();

      return response as Map<String, dynamic>?;
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserOffice(session, userId) async {
    try {
      final user = await supabase
          .from(ApiConstant.tableUsers)
          .select("office_id")
          .eq("id", userId)
          .maybeSingle();

      return user;
    } catch (e) {
      throw Exception("User dont have office");
    }
  }
}
