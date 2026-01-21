import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const url = 'https://jpksiqtapxasaqutkrhh.supabase.co';
  static const key = 'sb_publishable_wqoOP-oikiB31asXOuWkng_r9Mb_p59';

  static Null get instance => null;

  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    await Supabase.initialize(url: url, anonKey: key);
  }
}
