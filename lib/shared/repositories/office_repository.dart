import 'package:supabase_flutter/supabase_flutter.dart';

class OfficeRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> getOfficeById(String officeId) async {
    try {
      final response = await supabase
          .from('offices')
          .select()
          .eq('id', officeId)
          .single();

      return response as Map<String, dynamic>?;
    } catch (e) {
      throw Exception('Error fetching office: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAllOffices() async {
    try {
      final response = await supabase.from('offices').select();

      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Error fetching offices: $e');
    }
  }
}
