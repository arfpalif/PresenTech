import 'package:get/get.dart';
import 'package:presentech/features/hrd/attendance/repositories/hrd_attendance_repository.dart';
import 'package:presentech/shared/models/absence.dart';
import 'package:presentech/utils/enum/absence_status.dart';
import 'package:presentech/utils/enum/filter.dart';

class HrdAttendanceController extends GetxController {
  //repository
  final attendanceRepo = HrdAttendanceRepository();

  //variables
  var statusAbsen = "".obs;
  var selectedFilter = Rxn<AbsenceFilter>();
  RxInt telat = 0.obs;
  RxInt hadir = 0.obs;
  RxInt alfa = 0.obs;

  late var filteredEmployees = ''.obs;

  RxList<Absence> absences = <Absence>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAbsence();
  }

  Future<Map<String, dynamic>?> getTodayAbsence() async {
    final absence = await attendanceRepo.getTodayAbsence();

    return absence;
  }

  Future<void> fetchAbsence() async {
    try {
      final response = await attendanceRepo.fetchAbsence();
      absences.assignAll(response?['data'] ?? []);
      _updateSummary();
    } catch (e) {
      print("Error fetch Absence: $e");
      throw Exception("Failed to fetch absences");
    }
  }

  void _updateSummary() {
    print("Updating summary: absences count = ${absences.length}");
    
    final today = DateTime.now();
    final todayStr = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    print("Filtering for today: $todayStr");

    final todayAbsences = absences.where((a) {
      final aDateStr = "${a.date.year}-${a.date.month.toString().padLeft(2, '0')}-${a.date.day.toString().padLeft(2, '0')}";
      return aDateStr == todayStr;
    }).toList();

    print("Today's absences found: ${todayAbsences.length}");
    if (todayAbsences.isEmpty && absences.isNotEmpty) {
      print("First absence date in list: ${absences.first.date}");
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
    
    print("Summary counts -> Hadir: ${hadir.value}, Telat: ${telat.value}, Alpha: ${alfa.value}");
  }

  void changeFilter(AbsenceFilter? filter) {
    selectedFilter.value = selectedFilter.value == filter ? null : filter;

    fetchAbsenceByDay(selectedFilter.value);
  }

  Future<void> fetchAbsenceByDay(AbsenceFilter? selectedFilter) async {
    try {
      isLoading.value = true;

      final now = DateTime.now();

      if (selectedFilter == null) {
        final response = await attendanceRepo.fetchAbsence();
        absences.assignAll(response?['data'] ?? []);
        return;
      }

      late DateTime startDate;

      switch (selectedFilter) {
        case AbsenceFilter.today:
          startDate = DateTime(now.year, now.month, now.day);
          break;
        case AbsenceFilter.week:
          startDate = now.subtract(const Duration(days: 7));
          break;
        case AbsenceFilter.month:
          startDate = DateTime(now.year, now.month, 1);
          break;
      }

      final response = await attendanceRepo.fetchAbsenceByDateRange(
        startDate,
        now,
      );

      final data = (response as List).map((e) => Absence.fromJson(e)).toList();

      absences.assignAll(data);
    } finally {
      isLoading.value = false;
    }
  }
}
