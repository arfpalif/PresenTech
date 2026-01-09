import 'package:presentech/constants/api_constant.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HrdProfileRepository {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> getUser(String userId) async {
    final response = await supabase
        .from(ApiConstant.tableUsers)
        .select('name, profile_picture, role')
        .eq('id', userId)
        .maybeSingle();
    return response ?? {};
  }
}
