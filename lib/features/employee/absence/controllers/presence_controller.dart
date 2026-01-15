import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:presentech/features/employee/absence/repositories/absence_repository.dart';
import 'package:presentech/shared/models/absence.dart';
import 'package:presentech/utils/enum/absence_status.dart';
import 'package:presentech/utils/enum/filter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presentech/shared/view/components/snackbar/failed_snackbar.dart';
import 'package:presentech/shared/view/components/snackbar/success_snackbar.dart';

class PresenceController extends GetxController {
  // Repository
  final _absenceRepo = AbsenceRepository();

  // Supabase
  final _supabase = Supabase.instance.client;
  String get _userId => _supabase.auth.currentUser?.id ?? "";

  // Observables
  final clockIn = false.obs;
  final clockOut = false.obs;
  final statusAbsen = "Belum absen".obs;
  final selectedFilter = Rxn<DateFilter>();
  final absences = <Absence>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    refreshPresenceData();
  }

  Future<void> refreshPresenceData() async {
    await Future.wait([checkTodayAbsence(), fetchAbsence()]);
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
      statusAbsen.value = "Belum absen";
    } else {
      clockIn.value = absence['clock_in'] != null;
      clockOut.value = absence['clock_out'] != null;

      if (clockIn.value && !clockOut.value) {
        statusAbsen.value = "Sudah clockIn, belum clock out";
      } else if (clockIn.value && clockOut.value) {
        statusAbsen.value = "Sudah absen dan clock out";
      }
    }
  }

  Future<String> _determineAbsenceStatus() async {
    final userOffice = await _absenceRepo.getUserOffice(userId: _userId);
    if (userOffice == null) throw Exception("User tidak memiliki kantor");

    final workTime = await _absenceRepo.getOfficeHours(
      officeId: userOffice['office_id'],
    );
    if (workTime == null) throw Exception("Jam kerja tidak ditemukan");

    return _compareWithWorkStart(workTime['start_time']);
  }

  String _compareWithWorkStart(String startTime) {
    final now = DateTime.now();
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

  Future<void> submitAbsence() async {
    try {
      final todayAbsence = await _getTodayAbsenceData();
      if (todayAbsence != null &&
          todayAbsence['clock_in'] != null &&
          todayAbsence['clock_out'] != null) {
        FailedSnackbar.show("Hari ini sudah absen lengkap");
        return;
      }

      final position = await _getCurrentLocation();
      final office = await _getOfficeData();

      final distance = calculateDistance(
        position!.latitude,
        position.longitude,
        office['latitude'] ?? 0.0,
        office['longitude'] ?? 0.0,
      );

      if (distance > (office['radius'] ?? 100)) {
        FailedSnackbar.show(
          "Gagal absen, di luar area kantor (${distance.toStringAsFixed(1)} m)",
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

  void changeFilter(DateFilter filter) {
    selectedFilter.value = (selectedFilter.value == filter) ? null : filter;
    fetchAbsenceByDay();
  }

  Future<void> fetchAbsenceByDay() async {
    if (_userId.isEmpty) return;

    try {
      isLoading.value = true;
      DateTime? startDate;
      final now = DateTime.now();

      if (selectedFilter.value != null) {
        switch (selectedFilter.value!) {
          case DateFilter.today:
            startDate = DateTime(now.year, now.month, now.day);
            break;
          case DateFilter.week:
            startDate = now.subtract(const Duration(days: 7));
            break;
          case DateFilter.month:
            startDate = DateTime(now.year, now.month, 1);
            break;
        }
      }

      final response = await _absenceRepo.getAbsencesByFilter(
        userId: _userId,
        startDate: startDate,
        endDate: now,
      );
      absences.assignAll(response.map((e) => Absence.fromJson(e)));
    } catch (e) {
      FailedSnackbar.show("Gagal memfilter absensi");
    } finally {
      isLoading.value = false;
    }
  }
}
