import 'package:get/get.dart';
import 'package:presentech/constants/api_constant.dart';
import 'package:presentech/shared/models/absence.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HrdAttendanceRepository {
  final SupabaseClient supabase = Supabase.instance.client;
  RxList<Absence> absences = <Absence>[].obs;

  Future<Map<String, dynamic>?> getTodayAbsence() async {
    final today = DateTime.now().toIso8601String().split("T")[0];

    final absence = await supabase
        .from(ApiConstant.tableAbsences)
        .select(
          'id, created_at, date, clock_in, clock_out, status, user_id, users(name)',
        )
        .eq("date", today)
        .maybeSingle();

    return absence;
  }

  Future<Map<String, dynamic>?> fetchAbsence() async {
    try {
      final response = await supabase
          .from(ApiConstant.tableAbsences)
          .select(
            'id, created_at, date, clock_in, clock_out, status, user_id, users(name)',
          )
          .order('created_at', ascending: false);
      absences.value = response
          .map<Absence>((item) => Absence.fromJson(item))
          .toList();
      print("Absences fetched: ${absences.length}");
      return {"data": absences};
    } catch (e) {
      throw Exception("Failed to fetch absences");
    }
  }

  Future<List<Map<String, dynamic>>> fetchAbsenceByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final response = await supabase
        .from(ApiConstant.tableAbsences)
        .select(
          'id, created_at, date, clock_in, clock_out, status, user_id, users(name)',
        )
        .gte('created_at', startDate.toIso8601String())
        .lte('created_at', endDate.toIso8601String())
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}
