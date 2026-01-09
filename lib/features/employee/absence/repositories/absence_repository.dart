import 'package:flutter/material.dart';
import 'package:presentech/constants/api_constant.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AbsenceRepository {
  // Repository methods will be defined here
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getAllAbsences({
    required String userId,
  }) async {
    final absences = await supabase
        .from('absences')
        .select()
        .eq('user_id', userId)
        .order('date', ascending: false);

    return List<Map<String, dynamic>>.from(absences);
  }

  Future<Map<String, dynamic>?> getTodayAbsence({
    String? userId,
    String? today,
  }) async {
    final absence = await supabase
        .from('absences')
        .select()
        .eq('user_id', userId!)
        .eq("date", today!)
        .maybeSingle();
    debugPrint("today absence => ${absence.runtimeType.toString()}");
    return absence;
  }

  Future<Map<String, dynamic>?> getUserOffice({required String userId}) async {
    final office = await supabase
        .from(ApiConstant.tableUsers)
        .select('office_id')
        .eq('id', userId)
        .maybeSingle();

    return office;
  }

  Future<Map<String, dynamic>?> getOffice({required int officeId}) async {
    final profile = await supabase
        .from(ApiConstant.tableOffices)
        .select()
        .eq('id', officeId)
        .maybeSingle();

    return profile;
  }

  Future<Map<String, dynamic>?> getOfficeHours({required int officeId}) async {
    final officeHours = await supabase
        .from('work_schedules')
        .select('start_time, end_time')
        .eq('id', officeId)
        .maybeSingle();

    return officeHours;
  }

  Future<void> clockIn({
    required String userId,
    required dynamic status,
    required String date,
    required String time,
    required String clockIn,
  }) async {
    await supabase.from('absences').insert({
      'user_id': userId,
      'status': status,
      'date': date,
      'clock_in': time,
    });
  }

  Future<void> clockOut({
    required String userId,
    required String date,
    required String time,
  }) async {
    await supabase
        .from('absences')
        .update({'clock_out': time})
        .eq('user_id', userId)
        .eq('date', date);
  }
}
