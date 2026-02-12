import 'package:supabase_flutter/supabase_flutter.dart';

class UserSessionRemoteDataSource {
  final SupabaseClient _supabase;

  UserSessionRemoteDataSource({SupabaseClient? supabaseClient})
    : _supabase = supabaseClient ?? Supabase.instance.client;

  String? getCurrentUserId() {
    return _supabase.auth.currentUser?.id;
  }
}
