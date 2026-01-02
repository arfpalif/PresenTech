import 'package:get/get.dart';
import 'package:presentech/shared/models/absence.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HrdAttendanceRepository {
  final SupabaseClient supabase = Supabase.instance.client;
  RxList<Absence> absences = <Absence>[].obs;

  Future<Map<String, dynamic>?> getTodayAbsence() async {
    final today = DateTime.now().toIso8601String().split("T")[0];

    final absence = await supabase
        .from('absences')
        .select()
        .eq("date", today)
        .maybeSingle();

    return absence;
  }

  Future<Map<String, dynamic>?> fetchAbsence() async {
    try {
      final response = await supabase
          .from('absences')
          .select(
            'id, created_at, date, clock_in, clock_out, status, user_id, users(name)',
          )
          .order('created_at', ascending: false);
      absences.value = response
          .map<Absence>((item) => Absence.fromJson(item))
          .toList();
    } catch (e) {
      print("Error fetch Absence: $e");
    } finally {}
  }
}
