import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/hrd/attendance/repositories/hrd_attendance_repository.dart';
import 'package:presentech/shared/models/absence.dart';
import 'package:presentech/shared/view/components/snackbar/failed_snackbar.dart';
import 'package:presentech/utils/database/dao/absence_dao.dart';
import 'package:presentech/utils/enum/absence_status.dart';
import 'package:presentech/utils/enum/filter.dart';

class HrdAttendanceController extends GetxController {
  //repository
  final attendanceRepo = HrdAttendanceRepository();

  //dao
  final absenceDao = Get.find<AbsenceDao>();

  //variables
  var statusAbsen = "".obs;
  var selectedFilter = Rxn<DateFilter>();
  RxInt telat = 0.obs;
  RxInt hadir = 0.obs;
  RxInt alfa = 0.obs;
  RxList<Absence> allAbsences = <Absence>[].obs;
  RxList<Absence> absences = <Absence>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAbsence();
  }

  Future<void> fetchAbsence() async {
    try {
      final response = await attendanceRepo.fetchAbsence();
      allAbsences.assignAll(response);
    } catch (e) {
      debugPrint('Error fetching absences: $e');
      FailedSnackbar.show('Failed to fetch absences');
    }
    if (allAbsences.isEmpty) {
      try {
        final localData = await absenceDao.getAllAbsences();
        allAbsences.assignAll(
          localData.map((e) => Absence.fromDrift(e)).toList(),
        );
      } catch (e) {
        debugPrint("Gagal fetch local (Absences): $e");
        FailedSnackbar.show('Failed to fetch local absences');
      }
    }

    _applyFilter(selectedFilter.value);
    _updateSummary();
  }

  List<Absence> get absenceToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return allAbsences.where((t) {
      final start = DateTime(t.date.year, t.date.month, t.date.day);
      final end = DateTime(t.date.year, t.date.month, t.date.day);
      return !start.isAfter(today) && !end.isBefore(today);
    }).toList();
  }

  List<Absence> get absenceWeekly {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekAgo = today.subtract(const Duration(days: 7));
    return allAbsences.where((t) {
      final start = DateTime(t.date.year, t.date.month, t.date.day);
      final end = DateTime(t.date.year, t.date.month, t.date.day);
      return !start.isAfter(today) && !end.isBefore(weekAgo);
    }).toList();
  }

  List<Absence> get absenceMonthly {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final monthAgo = DateTime(now.year, now.month - 1, now.day);
    return allAbsences.where((t) {
      final start = DateTime(t.date.year, t.date.month, t.date.day);
      final end = DateTime(t.date.year, t.date.month, t.date.day);
      return !start.isAfter(today) && !end.isBefore(monthAgo);
    }).toList();
  }

  void _updateSummary() {
    final today = DateTime.now();
    final todayStr =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    print("Filtering for today: $todayStr");

    final todayAbsences = allAbsences.where((a) {
      final aDateStr =
          "${a.date.year}-${a.date.month.toString().padLeft(2, '0')}-${a.date.day.toString().padLeft(2, '0')}";
      return aDateStr == todayStr;
    }).toList();

    print("Today's absences found: ${todayAbsences.length}");
    if (todayAbsences.isEmpty && allAbsences.isNotEmpty) {
      print("First absence date in list: ${allAbsences.first.date}");
    }

    telat.value = todayAbsences
        .where((absence) => absence.status == AbsenceStatus.terlambat)
        .length;

    hadir.value = todayAbsences
        .where((absence) => absence.status == AbsenceStatus.hadir)
        .length;

    alfa.value = todayAbsences
        .where((absence) => absence.status == AbsenceStatus.alfa)
        .length;

    print(
      "Summary counts -> Hadir: ${hadir.value}, Telat: ${telat.value}, Alpha: ${alfa.value}",
    );
  }

  void changeFilter(DateFilter? filter) {
    selectedFilter.value = selectedFilter.value == filter ? null : filter;

    fetchAbsenceByDay(selectedFilter.value);
  }

  void _applyFilter(DateFilter? filter) {
    switch (filter) {
      case null:
        absences.assignAll(allAbsences);
        break;
      case DateFilter.today:
        absences.assignAll(absenceToday);
        break;
      case DateFilter.week:
        absences.assignAll(absenceWeekly);
        break;
      case DateFilter.month:
        absences.assignAll(absenceMonthly);
        break;
    }
  }

  Future<void> fetchAbsenceByDay(DateFilter? selectedFilter) async {
    try {
      isLoading.value = true;

      if (selectedFilter == null || allAbsences.isEmpty) {
        await fetchAbsence();
        return;
      }

      _applyFilter(selectedFilter);
    } finally {
      isLoading.value = false;
    }
  }
}
