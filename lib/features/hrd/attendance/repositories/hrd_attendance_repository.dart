import 'package:get/get.dart';
import 'package:presentech/constants/api_constant.dart';
import 'package:presentech/shared/models/absence.dart';
import 'package:presentech/shared/view/components/snackbar/failed_snackbar.dart';
import 'package:presentech/utils/database/dao/absence_dao.dart';
import 'package:presentech/utils/services/connectivity_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HrdAttendanceRepository {
  final SupabaseClient supabase = Supabase.instance.client;
  RxList<Absence> absences = <Absence>[].obs;
  final ConnectivityService connectivityService =
      Get.find<ConnectivityService>();
  final AbsenceDao _absenceDao = Get.find<AbsenceDao>();

  Future<List<Absence>> fetchAbsence() async {
    List<Absence> remoteAbsence = [];

    try {
      if (connectivityService.isOnline.value) {
        final response = await supabase
            .from(ApiConstant.tableAbsences)
            .select(
              'id, created_at, date, clock_in, clock_out, status, user_id, users(name)',
            )
            .order('created_at', ascending: false);

        remoteAbsence = (response as List)
            .map((e) => Absence.fromJson(e))
            .toList();

        if (remoteAbsence.isNotEmpty) {
          await _absenceDao.syncAbsenceToLocal(
            remoteAbsence.map((e) => e.toDrift()).toList(),
          );
        }
      }
    } catch (e) {
      FailedSnackbar.show('Failed to fetch absences from server : $e');
      throw Exception("Failed to fetch absences: $e");
    }
    return remoteAbsence;
  }

  Future<List<Absence>> fetchAbsenceByDateRange(
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

    absences.value = (response as List)
        .map((e) => Absence.fromJson(e))
        .toList();

    return absences;
  }
}
