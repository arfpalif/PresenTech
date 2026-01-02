import 'package:get/get.dart';
import 'package:presentech/features/hrd/attendance/repositories/hrd_attendance_repository.dart';
import 'package:presentech/shared/models/absence.dart';

enum AbsenceFilter { today, week, month }

class HrdAttendanceController extends GetxController {
  //repository
  final attendanceRepo = HrdAttendanceRepository();

  //variables
  var statusAbsen = "".obs;
  var selectedFilter = Rxn<AbsenceFilter>();
  RxInt telat = 0.obs;
  RxInt hadir = 0.obs;
  RxInt alfa = 0.obs;

  var filteredEmployees;

  RxList<Absence> absences = <Absence>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAbsence();
  }

  Future<Map<String, dynamic>?> getTodayAbsence() async {
    final today = DateTime.now().toIso8601String().split("T")[0];

    final absence = await attendanceRepo.getTodayAbsence();

    return absence;
  }

  Future<void> fetchAbsence() async {
    try {
      final response = await attendanceRepo.fetchAbsence();
    } catch (e) {
      print("Error fetch Absence: $e");
    } finally {}
  }

  Future<void> fetchAbsenceToday() async {
    try {
      final response = await attendanceRepo.getTodayAbsence();

      telat.value = absences
          .where((absence) => absence.status == 'telat')
          .length;

      hadir.value = absences
          .where((absence) => absence.status == 'hadir')
          .length;

      alfa.value = absences.where((absence) => absence.status == 'alfa').length;
    } catch (e) {
      print("Error fetch Absence: $e");
    } finally {}
  }

  void changeFilter(AbsenceFilter filter) {
    if (selectedFilter.value == filter) {
      selectedFilter.value = null;
    } else {
      selectedFilter.value = filter;
    }
    fetchAbsenceByDay();
  }

  Future<void> fetchAbsenceByDay() async {
    try {
      isLoading.value = true;

      final now = DateTime.now();

      if (selectedFilter.value == null) {
        final response = await attendanceRepo.fetchAbsence();

        final data = (response as List)
            .map((e) => Absence.fromJson(e))
            .toList();

        absences.assignAll(data);
        return;
      }

      late DateTime startDate;
      late DateTime endDate;

      switch (selectedFilter.value!) {
        case AbsenceFilter.today:
          startDate = DateTime(now.year, now.month, now.day);
          endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
          break;
        case AbsenceFilter.week:
          // Mulai dari Senin minggu ini
          final weekday = now.weekday; // 1 = Monday, 7 = Sunday
          startDate = DateTime(
            now.year,
            now.month,
            now.day,
          ).subtract(Duration(days: weekday - 1));
          endDate = startDate.add(
            Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
          );
          break;
        case AbsenceFilter.month:
          startDate = DateTime(now.year, now.month, 1);
          endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
          break;
      }

      final response = await attendanceRepo.fetchAbsence();

      final data = (response as List).map((e) => Absence.fromJson(e)).toList();

      absences.assignAll(data);
    } finally {
      isLoading.value = false;
    }
  }
}
