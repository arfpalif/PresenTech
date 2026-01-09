import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:presentech/features/employee/absence/repositories/absence_repository.dart';
import 'package:presentech/shared/models/absence.dart';
import 'package:presentech/utils/enum/absence_status.dart';
import 'package:presentech/utils/enum/filter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PresenceController extends GetxController {
  //repository
  final absenceRepo = AbsenceRepository();

  final supabase = Supabase.instance.client;
  var clockIn = false.obs;
  var clockOut = false.obs;
  RxString statusAbsen = "".obs;
  var selectedFilter = Rxn<AbsenceFilter>();

  RxList<Absence> absences = <Absence>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getTodayAbsence();
    checkTodayAbsence();
    fetchAbsence();
  }

  Future<Map<String, dynamic>?> getTodayAbsence() async {
    final Session? session = supabase.auth.currentSession;
    if (session == null) {
      return null;
    }
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final userId = session.user.id;
    final absence = await absenceRepo.getTodayAbsence(
      userId: userId,
      today: today,
    );
    return absence;
  }

  Future<void> checkTodayAbsence() async {
    final absence = await getTodayAbsence();

    if (absence == null) {
      clockIn.value = false;
      clockOut.value = false;
      statusAbsen.value = "Belum absen";

      return;
    } else if (absence['clock_in'] != null && absence['clock_out'] == null) {
      statusAbsen.value = "Sudah clockIn, belum clock out";
      clockIn.value = true;
    } else if (absence['clock_in'] != null && absence['clock_out'] != null) {
      clockIn.value = true;
      clockOut.value = true;
      statusAbsen.value = "Sudah absen dan clock out";
    }
  }

  Future<String?> checkTime() async {
    final Session? session = supabase.auth.currentSession;
    if (session == null) {
      return null;
    }
    final userId = session.user.id;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('HH:mm:ss').format(now);

    final userOffice = await absenceRepo.getUserOffice(userId: userId);

    print(userOffice);

    print(formattedDate);

    final workTime = await absenceRepo.getOfficeHours(
      officeId: userOffice?['office_id'],
    );
    print("ini jam : $workTime");
    if (workTime == null) throw Exception("Jam kerja tidak ada");

    final startTime = workTime['start_time'];

    return compareTime(startTime);
  }

  DateTime parseTime(String time) {
    final parts = time.split(':');
    final now = DateTime.now();

    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]), // hour
      int.parse(parts[1]), // minute
      int.parse(parts[2]), // second
    );
  }

  String compareTime(String startTime) {
    final now = DateTime.now();
    final workStart = parseTime(startTime);

    if (now.isBefore(workStart) || now.isAtSameMomentAs(workStart)) {
      return "hadir";
    }
    final late = workStart.add(Duration(hours: 1));

    if (now.isAfter(workStart) && now.isBefore(late)) {
      return AbsenceStatus.terlambat.name;
    }
    return AbsenceStatus.alfa.name;
  }

  Future<void> clockInAbsence() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final absence = await getTodayAbsence();
      final today = DateTime.now().toIso8601String().split("T")[0];
      final status = await checkTime();

      if (absence != null) {
        Get.snackbar("Error", "Anda sudah absen hari ini");
      } else {
        final response = await absenceRepo.clockIn(
          userId: userId,
          date: today,
          status: status ?? "unknown",
          clockIn: DateTime.now().toIso8601String().split("T")[1],
          time: DateTime.now().toIso8601String().split("T")[1],
        );

        clockIn.value = true;
        return response;
      }
    } catch (e) {
      print("Error clock in: $e");
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> clockOutAbsence() async {
    try {
      final user = supabase.auth.currentUser!.id;
      final today = DateTime.now().toIso8601String().split("T")[0];

      final response = await absenceRepo.clockOut(
        userId: user,
        date: today,
        time: DateTime.now().toIso8601String().split("T")[1],
      );

      clockOut.value = true;
      return response;
    } catch (e) {
      Get.snackbar("Error", "Anda sudah absen hari ini");
    } finally {}
  }

  Future<Map<String, dynamic>> getOffice() async {
    final session = supabase.auth.currentSession;
    final userId = session?.user.id;

    if (userId == null) {
      throw Exception("Error, User not login");
    }

    final user = await absenceRepo.getUserOffice(userId: userId);

    print("user row => $user");
    print("office id => ${user?['office_id']}");

    final officeId = user?['office_id'];

    if (user == null || officeId == null) {
      Get.snackbar("Error", "User tidak termasuk dalam office apapun");
      throw Exception("User dont have office");
    }

    final office = await absenceRepo.getOffice(officeId: officeId);
    print("office row => $office");

    if (office == null) {
      Get.snackbar("Error", "Tidak ada office");
      throw Exception("Error");
    }
    return office;
  }

  Future<Position?> getCurrentLocation() async {
    bool service = await Geolocator.isLocationServiceEnabled();
    if (!service) {
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
      return Future.error("Error forever, could not get location");
    } else {
      return await Geolocator.getCurrentPosition();
    }
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

  Future<void> absence() async {
    final todayAbsence = await getTodayAbsence();

    if (todayAbsence != null &&
        todayAbsence['clock_in'] != null &&
        todayAbsence['clock_out'] != null) {
      Get.snackbar("Error", "Hari ini sudah absen");
      return;
    }

    final position = await getCurrentLocation();
    if (position == null) {
      Get.snackbar("Error", "Gagal mendapatkan lokasi");
      return;
    }
    final office = await getOffice();
    print(" office data: $office ");
    final distance = calculateDistance(
      position.latitude,
      position.longitude,
      office['latitude'] ?? 0.0,
      office['longitude'] ?? 0.0,
    );

    if (distance > office['radius']) {
      Get.snackbar("Error", "Gagal absen, di luar area kantor ($distance m)");
      return;
    }

    if (todayAbsence == null) {
      await clockInAbsence();
      Get.snackbar("Sukses", "Berhasil clock in");
      checkTodayAbsence();
    } else {
      await clockOutAbsence();
      Get.snackbar("Sukses", "Berhasil clock out");
      await fetchAbsence();
      checkTodayAbsence();
    }
  }

  Future<void> fetchAbsence() async {
    final userId = supabase.auth.currentSession?.user.id;
    if (userId == null) {
      throw Exception("Error");
    }

    try {
      isLoading.value = true;
      final response = await absenceRepo.getAllAbsences(userId: userId);
      print("Fetch Absence Response: $response");
      absences.value = response
          .map<Absence>((item) => Absence.fromJson(item))
          .toList();
      print("Absences loaded: ${absences.length} items");
    } catch (e) {
      print("Error fetch Absence: $e");
      Get.snackbar("Error", "Gagal fetch absensi: $e");
    } finally {
      isLoading.value = false;
    }
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
