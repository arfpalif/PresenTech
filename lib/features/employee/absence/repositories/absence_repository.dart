import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:presentech/constants/api_constant.dart';
import 'package:presentech/features/hrd/location/model/office.dart';
import 'package:presentech/shared/models/absence.dart';
import 'package:presentech/shared/models/users.dart';
import 'package:presentech/utils/database/dao/absence_dao.dart';
import 'package:presentech/utils/database/dao/location_dao.dart';
import 'package:presentech/utils/database/dao/profile_dao.dart';
import 'package:presentech/utils/enum/absence_status.dart';
import 'package:presentech/utils/services/connectivity_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AbsenceRepository {
  final SupabaseClient supabase = Supabase.instance.client;
  final ConnectivityService connectivityService =
      Get.find<ConnectivityService>();
  final AbsenceDao _absenceDao = Get.find<AbsenceDao>();
  final LocationDao _locationDao = Get.find<LocationDao>();
  final ProfileDao _profileDao = Get.find<ProfileDao>();

  Future<List<Map<String, dynamic>>> getAbsencesByFilter({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (connectivityService.isOnline.value) {
      var query = supabase
          .from(ApiConstant.tableAbsences)
          .select()
          .eq('user_id', userId);

      if (startDate != null) {
        query = query.gte('date', startDate.toIso8601String().split('T')[0]);
      }
      if (endDate != null) {
        query = query.lte('date', endDate.toIso8601String().split('T')[0]);
      }

      final response = await query.order('created_at', ascending: false);
      final data = List<Map<String, dynamic>>.from(response);

      await _absenceDao.syncAbsenceToLocal(
        data.map((e) => Absence.fromJson(e).toDrift()).toList(),
      );

      return data;
    } else {
      debugPrint(
        "AbsenceRepository: Fetching absences offline for $userId within range",
      );
      final localData = (startDate != null && endDate != null)
          ? await _absenceDao.getAbsencesByRange(userId, startDate, endDate)
          : await _absenceDao.getAbsencesByUser(userId);

      debugPrint(
        "AbsenceRepository: Found ${localData.length} records locally",
      );
      return localData.map((e) => Absence.fromDrift(e).toJson()).toList();
    }
  }

  Future<Map<String, dynamic>?> getTodayAbsence({
    required String userId,
    required String today,
  }) async {
    if (connectivityService.isOnline.value) {
      final response = await supabase
          .from(ApiConstant.tableAbsences)
          .select()
          .eq('user_id', userId)
          .eq("date", today)
          .maybeSingle();

      if (response != null) {
        await _absenceDao.syncAbsenceToLocal([
          Absence.fromJson(response).toDrift(),
        ]);
      }
      return response;
    } else {
      final dateOnly = today.split(' ')[0]; // Ensure only date part
      debugPrint(
        "AbsenceRepository: Getting today's absence offline for $userId on $dateOnly",
      );
      final local = await _absenceDao.getAbsenceByDate(userId, dateOnly);
      if (local == null) {
        debugPrint("AbsenceRepository: No local absence found for $dateOnly");
      }
      return local != null ? Absence.fromDrift(local).toJson() : null;
    }
  }

  Future<Map<String, dynamic>?> getUserOffice({required String userId}) async {
    if (connectivityService.isOnline.value) {
      try {
        final response = await supabase
            .from(ApiConstant.tableUsers)
            .select('office_id')
            .eq('id', userId)
            .maybeSingle();

        if (response != null && response['office_id'] != null) {
          final officeId = response['office_id'] is String
              ? int.parse(response['office_id'])
              : response['office_id'] as int;

          final fullProfile = await supabase
              .from(ApiConstant.tableUsers)
              .select()
              .eq('id', userId)
              .maybeSingle();
          if (fullProfile != null) {
            final user = Users.fromJson(fullProfile);
            await _profileDao.saveProfile(user.toDrift());
          }
          return {'office_id': officeId};
        }
        return response;
      } catch (e) {
        debugPrint("AbsenceRepository: Error fetching user office online: $e");
      }
    }

    final localUser = await _profileDao.getProfileLocally(userId);
    if (localUser != null && localUser.officeId != null) {
      return {'office_id': localUser.officeId};
    }
    return null;
  }

  Future<Map<String, dynamic>?> getOffice({required int officeId}) async {
    if (connectivityService.isOnline.value) {
      try {
        final response = await supabase
            .from(ApiConstant.tableOffices)
            .select()
            .eq('id', officeId)
            .maybeSingle();

        if (response != null) {
          final office = Office.fromJson(
            Map<String, dynamic>.from(response as Map),
          );
          await _locationDao.insertLocation(office.toDrift());
          return office.toJson();
        }
      } catch (e) {
        debugPrint("AbsenceRepository: Error fetching office online: $e");
      }
    }

    final localOffice = await _locationDao.getLocationById(officeId);
    if (localOffice != null) {
      return Office.fromDrift(localOffice).toJson();
    }
    return null;
  }

  Future<Map<String, dynamic>?> getOfficeHours({required int officeId}) async {
    if (connectivityService.isOnline.value) {
      try {
        final response = await supabase
            .from('work_schedules')
            .select('start_time, end_time')
            .eq('id', officeId)
            .maybeSingle();
        if (response != null) return response;
      } catch (e) {
        debugPrint("AbsenceRepository: Error fetching office hours: $e");
      }
    }

    // Try to get from local offices table
    final localOffice = await _locationDao.getLocationById(officeId);
    if (localOffice != null &&
        localOffice.startTime != null &&
        localOffice.endTime != null) {
      return {
        'start_time': localOffice.startTime,
        'end_time': localOffice.endTime,
      };
    }

    return {'start_time': '09:00:00', 'end_time': '17:00:00'};
  }

  Future<void> syncOfficeData(String userId) async {
    if (!connectivityService.isOnline.value) return;

    try {
      debugPrint(
        "AbsenceRepository: Proactively syncing office data for $userId",
      );

      // 1. Sync Profile & Get Office ID
      final officeData = await getUserOffice(userId: userId);
      if (officeData == null || officeData['office_id'] == null) return;

      final officeId = officeData['office_id'] as int;

      // 2. Get Office Details
      final officeDetails = await getOffice(officeId: officeId);
      if (officeDetails == null) return;

      // 3. Get Office Hours
      final hours = await getOfficeHours(officeId: officeId);

      // 4. Save combined data to local
      if (hours != null) {
        final updatedOffice = Office.fromJson({
          ...officeDetails,
          'start_time': hours['start_time'],
          'end_time': hours['end_time'],
        });
        await _locationDao.insertLocation(updatedOffice.toDrift());
      }

      debugPrint("AbsenceRepository: Office data sync completed for $userId");
    } catch (e) {
      debugPrint("AbsenceRepository: Error proactive sync office data: $e");
    }
  }

  Future<void> clockIn({
    required String userId,
    required String status,
    required String date,
    required String clockIn,
  }) async {
    final Map<String, dynamic> data = {
      'user_id': userId,
      'status': status,
      'date': date,
      'clock_in': clockIn,
      'created_at': DateTime.now().toIso8601String(),
    };

    if (connectivityService.isOnline.value == true) {
      try {
        await supabase.from(ApiConstant.tableAbsences).insert({
          'user_id': userId,
          'status': status,
          'date': date,
          'clock_in': clockIn,
        });

        // Save to local as synced
        await _absenceDao.syncAbsenceToLocal([
          Absence(
            id: 0,
            createdAt: data['created_at'] as String,
            date: DateTime.parse(date),
            status: AbsenceStatus.values.firstWhere((e) => e.name == status),
            userId: userId,
            clockIn: clockIn,
            isSynced: 1,
            syncAction: null,
          ).toDrift(),
        ]);
      } catch (e) {
        debugPrint("Online clockIn failed, saving to local queue: $e");
        await _absenceDao.insertAbsence(
          Absence.fromJson(data)
            ..isSynced = 0
            ..syncAction = 'insert',
        );
      }
    } else {
      await _absenceDao.insertAbsence(
        Absence.fromJson(data)
          ..isSynced = 0
          ..syncAction = 'insert',
      );
      debugPrint("Internet Mati! Absen disimpan di HP dulu.");
    }
  }

  Future<void> clockOut({
    required String userId,
    required String date,
    required String clockOut,
  }) async {
    if (connectivityService.isOnline.value == true) {
      try {
        await supabase
            .from(ApiConstant.tableAbsences)
            .update({'clock_out': clockOut})
            .eq('user_id', userId)
            .eq('date', date);

        final local = await _absenceDao.getAbsenceByDate(userId, date);
        if (local != null) {
          final updated = Absence.fromDrift(local);
          updated.clockOut = clockOut;
          updated.isSynced = 1;
          updated.syncAction = null;
          await _absenceDao.syncAbsenceToLocal([updated.toDrift()]);
        }
      } catch (e) {
        debugPrint("Online clockOut failed, saving to local queue: $e");
        final local = await _absenceDao.getAbsenceByDate(userId, date);
        if (local != null) {
          final updated = Absence.fromDrift(local);
          updated.clockOut = clockOut;
          updated.isSynced = 0;
          updated.syncAction = 'update';
          await _absenceDao.updateAbsence(updated.toDrift());
        }
      }
    } else {
      final local = await _absenceDao.getAbsenceByDate(userId, date);
      if (local != null) {
        final updated = Absence.fromDrift(local);
        updated.clockOut = clockOut;
        updated.isSynced = 0;
        updated.syncAction = 'update';
        await _absenceDao.updateAbsence(updated.toDrift());
        debugPrint("Internet Mati! Clock out disimpan di HP dulu.");
      }
    }
  }

  Future<void> syncUnsyncedAbsences() async {
    final unsyncedData = await _absenceDao.getUnsyncedAbsences();
    final unsynced = unsyncedData.map((e) => Absence.fromDrift(e)).toList();

    if (unsynced.isEmpty) return;

    for (var absence in unsynced) {
      try {
        final userId = absence.userId;
        final dateStr = absence.date.toIso8601String().split('T').first;

        await supabase.from(ApiConstant.tableAbsences).upsert({
          'user_id': userId,
          'date': dateStr,
          'status': absence.status?.name ?? 'hadir',
          'clock_in': absence.clockIn,
          'clock_out': absence.clockOut,
        }, onConflict: 'user_id,date');

        await _absenceDao.markAbsenceAsSynced(userId, dateStr);
        debugPrint("Synced absence for $dateStr");
      } catch (e) {
        debugPrint("Failed to sync absence for ${absence.date}: $e");
      }
    }
  }

  Future<void> updateAbsenceStatus({
    required String userId,
    required String date,
    required String status,
    String? clockIn,
    String? clockOut,
  }) async {
    if (connectivityService.isOnline.value) {
      try {
        await supabase
            .from(ApiConstant.tableAbsences)
            .update({
              'status': status,
              if (clockIn != null) 'clock_in': clockIn,
              if (clockOut != null) 'clock_out': clockOut,
            })
            .eq('user_id', userId)
            .eq('date', date);

        final local = await _absenceDao.getAbsenceByDate(userId, date);
        if (local != null) {
          final updated = Absence.fromDrift(local);
          updated.status = AbsenceStatus.values.firstWhere(
            (e) => e.name == status,
          );
          if (clockIn != null) updated.clockIn = clockIn;
          if (clockOut != null) updated.clockOut = clockOut;
          updated.isSynced = 1;
          updated.syncAction = null;
          await _absenceDao.syncAbsenceToLocal([updated.toDrift()]);
        }
      } catch (e) {
        debugPrint(
          "Failed to update absence status online, saving to local queue: $e",
        );
        final local = await _absenceDao.getAbsenceByDate(userId, date);
        if (local != null) {
          final updated = Absence.fromDrift(local);
          updated.status = AbsenceStatus.values.firstWhere(
            (e) => e.name == status,
          );
          if (clockIn != null) updated.clockIn = clockIn;
          if (clockOut != null) updated.clockOut = clockOut;
          updated.isSynced = 0;
          updated.syncAction = 'update';
          await _absenceDao.updateAbsence(updated.toDrift());
        }
      }
    } else {
      final local = await _absenceDao.getAbsenceByDate(userId, date);
      if (local != null) {
        final updated = Absence.fromDrift(local);
        updated.status = AbsenceStatus.values.firstWhere(
          (e) => e.name == status,
        );
        if (clockIn != null) updated.clockIn = clockIn;
        if (clockOut != null) updated.clockOut = clockOut;
        updated.isSynced = 0;
        updated.syncAction = 'update';
        await _absenceDao.updateAbsence(updated.toDrift());
        debugPrint("Internet Mati! Update absence status disimpan di HP dulu.");
      }
    }
  }
}
