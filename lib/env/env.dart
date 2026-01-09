import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Env {
  final String baseUrl = dotenv.env['SUPABASE_URL'] ?? "";
  final String anonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? "";
}
