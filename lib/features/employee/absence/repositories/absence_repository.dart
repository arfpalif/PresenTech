import 'package:presentech/constants/api_constant.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AbsenceRepository {
  // Repository methods will be defined here
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getAbsencesByFilter({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    var query = supabase.from('absences').select().eq('user_id', userId);

    if (startDate != null) {
      query = query.gte('created_at', startDate.toIso8601String());
    }
    if (endDate != null) {
      query = query.lte('created_at', endDate.toIso8601String());
    }

    final response = await query.order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>?> getTodayAbsence({
    required String userId,
    required String today,
  }) async {
    return await supabase
        .from('absences')
        .select()
        .eq('user_id', userId)
        .eq("date", today)
        .maybeSingle();
  }

  Future<Map<String, dynamic>?> getUserOffice({required String userId}) async {
    return await supabase
        .from(ApiConstant.tableUsers)
        .select('office_id')
        .eq('id', userId)
        .maybeSingle();
  }

  Future<Map<String, dynamic>?> getOffice({required int officeId}) async {
    return await supabase
        .from(ApiConstant.tableOffices)
        .select()
        .eq('id', officeId)
        .maybeSingle();
  }

  Future<Map<String, dynamic>?> getOfficeHours({required int officeId}) async {
    return await supabase
        .from('work_schedules')
        .select('start_time, end_time')
        .eq('id', officeId)
        .maybeSingle();
  }

  Future<void> clockIn({
    required String userId,
    required String status,
    required String date,
    required String clockIn,
  }) async {
    await supabase.from('absences').insert({
      'user_id': userId,
      'status': status,
      'date': date,
      'clock_in': clockIn,
    });
  }

  Future<void> clockOut({
    required String userId,
    required String date,
    required String clockOut,
  }) async {
    await supabase
        .from('absences')
        .update({'clock_out': clockOut})
        .eq('user_id', userId)
        .eq('date', date);
  }

  Future<void> updateAbsenceStatus({
    required String userId,
    required String date,
    required String status,
    String? clockIn,
    String? clockOut,
  }) async {
    await supabase.from('absences').upsert({
      'user_id': userId,
      'date': date,
      'status': status,
      'clock_in': clockIn,
    }, onConflict: 'user_id,date');
  }
}
