import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:presentech/features/employee/absence/model/absence.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum AbsenceFilter { today, week, month }

class HrdAttendanceController extends GetxController {
  final supabase = Supabase.instance.client;
  var statusAbsen = "".obs;
  var selectedFilter = Rxn<AbsenceFilter>();

  RxList<Absence> absences = <Absence>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getTodayAbsence();
    fetchAbsence();
  }

  Future<Map<String, dynamic>?> getTodayAbsence() async {
    final today = DateTime.now().toIso8601String().split("T")[0];

    final absence = await supabase
        .from('absences')
        .select()
        .eq("date", today)
        .maybeSingle();

    return absence;
  }

  Future<Map<String, dynamic>> getOffice() async {
    final user = await supabase.from("users").select("office_id").maybeSingle();

    final officeId = user?['office_id'];

    if (user == null || officeId == null) {
      Get.snackbar("Error", "User tidak termasuk dalam office apapun");
      throw Exception("User dont have office");
    }

    final office = await supabase
        .from("offices")
        .select()
        .eq("id", officeId)
        .maybeSingle();
    print("office row => $office");

    if (office == null) {
      Get.snackbar("Error", "Tidak ada office");
      throw Exception("Error");
    }
    return office;
  }

  Future<Position> getCurrentLocation() async {
    bool service = await Geolocator.isLocationServiceEnabled();
    if (!service) {
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
      return Future.error("Error forever, could not get location");
    } else {
      return await Geolocator.getCurrentPosition();
    }
  }

  Future<void> fetchAbsence() async {
    try {
      final response = await supabase
          .from('absences')
          .select()
          .order('created_at', ascending: false);
      absences.value = response
          .map<Absence>((item) => Absence.fromJson(item))
          .toList();
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

      final userId = supabase.auth.currentUser!.id;
      final now = DateTime.now();

      if (selectedFilter.value == null) {
        final response = await supabase
            .from('absences')
            .select()
            .eq('user_id', userId)
            .order('created_at', ascending: false);

        final data = (response as List)
            .map((e) => Absence.fromJson(e))
            .toList();

        absences.assignAll(data);
        return;
      }

      late DateTime startDate;

      switch (selectedFilter.value!) {
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

      final response = await supabase
          .from('absences')
          .select()
          .eq('user_id', userId)
          .gte('created_at', startDate.toIso8601String())
          .lte('created_at', now.toIso8601String())
          .order('created_at', ascending: false);

      final data = (response as List).map((e) => Absence.fromJson(e)).toList();

      absences.assignAll(data);
    } finally {
      isLoading.value = false;
    }
  }
}
