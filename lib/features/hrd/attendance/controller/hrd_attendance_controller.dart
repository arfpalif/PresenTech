import 'package:get/get.dart';
import 'package:presentech/features/hrd/attendance/repositories/hrd_attendance_repository.dart';
import 'package:presentech/shared/models/absence.dart';
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
    fetchAbsenceToday();
  }

  Future<Map<String, dynamic>?> getTodayAbsence() async {
    final absence = await attendanceRepo.getTodayAbsence();

    return absence;
  }

  Future<void> fetchAbsence() async {
    try {
      final response = await attendanceRepo.fetchAbsence();
      absences.assignAll(response?['data'] ?? []);
    } catch (e) {
      print("Error fetch Absence: $e");
      throw Exception("Failed to fetch absences");
    }
  }

  Future<void> fetchAbsenceToday() async {
    try {
      await attendanceRepo.getTodayAbsence();

      telat.value = absences
          .where((absence) => absence.status == 'telat')
          .length;
      print(telat.value);

      hadir.value = absences
          .where((absence) => absence.status == 'hadir')
          .length;
      print(hadir.value);

      alfa.value = absences.where((absence) => absence.status == 'alfa').length;
    } catch (e) {
      throw Exception("Failed to fetch absences");
    }
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
