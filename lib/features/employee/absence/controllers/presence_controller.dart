import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/features/employee/absence/repositories/absence_repository.dart';
import 'package:presentech/shared/models/absence.dart';
import 'package:presentech/shared/view/components/snackbar/failed_form_snackbar.dart';
import 'package:presentech/utils/enum/absence_status.dart';
import 'package:presentech/utils/enum/filter.dart';
import 'package:presentech/utils/enum/permission_type.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presentech/shared/view/components/snackbar/failed_snackbar.dart';
import 'package:presentech/shared/view/components/snackbar/success_snackbar.dart';

class PresenceController extends GetxController {
  // Repository
  final AbsenceRepository _absenceRepo;
  final SupabaseClient _supabase;

  PresenceController({
    AbsenceRepository? absenceRepo,
    SupabaseClient? supabaseClient,
  })  : _absenceRepo = absenceRepo ?? AbsenceRepository(),
        _supabase = supabaseClient ?? Supabase.instance.client;

  String get _userId => _supabase.auth.currentUser?.id ?? "";

  // Observables
  final clockIn = false.obs;
  final clockOut = false.obs;
  final statusAbsen = "Belum absen".obs;
  final selectedFilter = Rxn<DateFilter>();
  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxList<Absence> absences = <Absence>[].obs;
  final isLoading = false.obs;
  RxInt telat = 0.obs;
  RxInt hadir = 0.obs;
  RxInt alfa = 0.obs;
  RxInt izin = 0.obs;
  final RxBool showForm = false.obs;
  final isIzin = false.obs;

  @override
  void onInit() {
    super.onInit();
    refreshPresenceData();
    fetchAbsenceByDay();
  }

  Future<void> refreshPresenceData() async {
    await Future.wait([checkTodayAbsence(), fetchAbsence()]);
  }

  Future<void> prevMonth() async {
    selectedDate.value = DateTime(
      selectedDate.value.year,
      selectedDate.value.month - 1,
      1,
    );
    await fetchAbsenceByDay();
  }

  Future<void> nextMonth() async {
    selectedDate.value = DateTime(
      selectedDate.value.year,
      selectedDate.value.month + 1,
      1,
    );
    await fetchAbsenceByDay();
  }

  Future<void> fetchAbsence() async {
    if (_userId.isEmpty) return;

    try {
      isLoading.value = true;
      final response = await _absenceRepo.getAbsencesByFilter(userId: _userId);
      absences.assignAll(response.map((item) => Absence.fromJson(item)));
    } catch (e) {
      FailedSnackbar.show("Gagal mengambil riwayat absensi");
    } finally {
      isLoading.value = false;
    }
  }

  List<Absence> get absencesToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return absences.where((a) {
      final absenceDate = DateTime(a.date.year, a.date.month, a.date.day);
      final end = DateTime(a.date.year, a.date.month, a.date.day);
      return !absenceDate.isAfter(today) && !end.isBefore(today);
    }).toList();
  }

  Future<Map<String, dynamic>?> _getTodayAbsenceData() async {
    if (_userId.isEmpty) return null;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return await _absenceRepo.getTodayAbsence(userId: _userId, today: today);
  }

  Future<void> checkTodayAbsence() async {
    final absence = await _getTodayAbsenceData();

    if (absence == null) {
      clockIn.value = false;
      clockOut.value = false;
      isIzin.value = false;
      statusAbsen.value = "Belum absen";
    } else {
      clockIn.value = absence['clock_in'] != null;
      clockOut.value = absence['clock_out'] != null;
      isIzin.value = absence['status'] == AbsenceStatus.izin.name;

      if (isIzin.value) {
        statusAbsen.value = "Izin";
      } else if (clockIn.value && !clockOut.value) {
        statusAbsen.value = "Sudah clockIn, belum clock out";
      } else if (clockIn.value && clockOut.value) {
        statusAbsen.value = "Sudah absen dan clock out";
      }
    }
  }

  Future<String> _determineAbsenceStatus({DateTime? customNow}) async {
    final userOffice = await _absenceRepo.getUserOffice(userId: _userId);
    if (userOffice == null) throw Exception("User tidak memiliki kantor");

    final workTime = await _absenceRepo.getOfficeHours(
      officeId: userOffice['office_id'],
    );
    if (workTime == null) throw Exception("Jam kerja tidak ditemukan");

    return _compareWithWorkStart(workTime['start_time'], customNow: customNow);
  }

  @visibleForTesting
  String compareWithWorkStartForTest(String startTime, {DateTime? customNow}) {
    return _compareWithWorkStart(startTime, customNow: customNow);
  }

  String _compareWithWorkStart(String startTime, {DateTime? customNow}) {
    final now = customNow ?? DateTime.now();
    final parts = startTime.split(':');
    final workStart = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );

    if (now.isBefore(workStart) || now.isAtSameMomentAs(workStart)) {
      return AbsenceStatus.hadir.name;
    }

    final lateThreshold = workStart.add(const Duration(hours: 1));
    return now.isBefore(lateThreshold)
        ? AbsenceStatus.terlambat.name
        : AbsenceStatus.alfa.name;
  }

  Future<void> _handleClockIn() async {
    final absence = await _getTodayAbsenceData();
    if (absence != null) {
      FailedSnackbar.show("Anda sudah absen hari ini");
      return;
    }

    final status = await _determineAbsenceStatus();
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    final time = DateFormat('HH:mm:ss').format(now);

    await _absenceRepo.clockIn(
      userId: _userId,
      date: today,
      status: status,
      clockIn: time,
    );
    clockIn.value = true;
    SuccessSnackbar.show("Berhasil clock in");
  }

  Future<void> _handleClockOut() async {
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    final time = DateFormat('HH:mm:ss').format(now);

    await _absenceRepo.clockOut(userId: _userId, date: today, clockOut: time);
    clockOut.value = true;
    SuccessSnackbar.show("Berhasil clock out");
  }

  Future<Map<String, dynamic>> _getOfficeData() async {
    final userOffice = await _absenceRepo.getUserOffice(userId: _userId);
    final officeId = userOffice?['office_id'];

    if (officeId == null) {
      FailedSnackbar.show("User tidak terdaftar di kantor manapun");
      throw Exception("Office not found for user");
    }

    final office = await _absenceRepo.getOffice(officeId: officeId);
    if (office == null) {
      FailedSnackbar.show("Data kantor tidak ditemukan");
      throw Exception("Office data is null");
    }
    return office;
  }

  Future<Position?> _getCurrentLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      await Geolocator.openLocationSettings();
      return Future.error("Location should be enabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Error, could not get location");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("Izin lokasi ditolak permanen");
    }

    return await Geolocator.getCurrentPosition();
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371000;
    final dLat = (lat2 - lat1) * pi / 180;
    final dLon = (lon2 - lon1) * pi / 180;

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  Future<void> submitAbsence({Position? customPosition, Map<String, dynamic>? customOffice}) async {
    try {
      final todayAbsence = await _getTodayAbsenceData();
      if (todayAbsence != null &&
          todayAbsence['status'] == AbsenceStatus.izin.name) {
        FailedSnackbar.show("Anda sedang izin hari ini");
        return;
      }

      if (todayAbsence != null &&
          todayAbsence['clock_in'] != null &&
          todayAbsence['clock_out'] != null) {
        FailedSnackbar.show("Hari ini sudah absen lengkap");
        return;
      }

      final position = customPosition ?? await _getCurrentLocation();
      final office = customOffice ?? await _getOfficeData();

      final distance = calculateDistance(
        position!.latitude,
        position.longitude,
        office['latitude'] ?? 0.0,
        office['longitude'] ?? 0.0,
      );

      if (distance > (office['radius'] ?? 100)) {
        FailedFormSnackbar.show(
          "Anda berada di luar jangkauan kantor. Jarak Anda: ${distance.toStringAsFixed(2)} meter",
          onCtaPressed: () {
            Get.toNamed(
              Routes.employeePermissionAdd,
              arguments: {
                'type': PermissionType.absence_error,
                'date': DateTime.now(),
              },
            );
          },
        );
        return;
      }

      if (todayAbsence == null) {
        await _handleClockIn();
      } else {
        await _handleClockOut();
      }

      await refreshPresenceData();
    } catch (e) {
      print("Absence Error: $e");
      FailedSnackbar.show(e.toString());
    }
  }

  List<Absence> get izinAbsences {
    return absences.where((a) {
      return a.date.year == selectedDate.value.year &&
          a.date.month == selectedDate.value.month;
    }).toList();
  }

  List<Absence> get monthlyAbsences {
    return absences.where((a) {
      return a.date.year == selectedDate.value.year &&
          a.date.month == selectedDate.value.month;
    }).toList();
  }

  Future<void> fetchAbsenceByDay() async {
    if (_userId.isEmpty) return;

    try {
      isLoading.value = true;
      DateTime startDate = DateTime(
        selectedDate.value.year,
        selectedDate.value.month,
        1,
      );

      DateTime endDate = DateTime(
        selectedDate.value.year,
        selectedDate.value.month + 1,
        0,
      );

      final response = await _absenceRepo.getAbsencesByFilter(
        userId: _userId,
        startDate: startDate,
        endDate: endDate,
      );
      final data = response.map((item) => Absence.fromJson(item)).toList();
      absences.assignAll(data);

      telat.value = data
          .where((absence) => absence.status == AbsenceStatus.terlambat)
          .length;

      hadir.value = data
          .where((absence) => absence.status == AbsenceStatus.hadir)
          .length;

      alfa.value = data
          .where((absence) => absence.status == AbsenceStatus.alfa)
          .length;
      izin.value = data
          .where((absence) => absence.status == AbsenceStatus.izin)
          .length;
    } catch (e) {
      FailedSnackbar.show("Gagal memfilter absensi");
    } finally {
      isLoading.value = false;
    }
  }
}
