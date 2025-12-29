import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:presentech/shared/models/absence.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum AbsenceFilter { today, week, month }

class PresenceController extends GetxController {
  final supabase = Supabase.instance.client;
  var clockIn = false.obs;
  var Clock_Out = false.obs;
  var statusAbsen = "".obs;
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
    final session = supabase.auth.currentSession;
    final userId = session?.user.id;
    final today = DateTime.now().toIso8601String().split("T")[0];
    if (userId == null) {
      return null;
    }
    final absence = await supabase
        .from('absences')
        .select()
        .eq('user_id', userId)
        .eq("date", today)
        .maybeSingle();

    return absence;
  }

  Future<void> checkTodayAbsence() async {
    final absence = await getTodayAbsence();

    if (absence == null) {
      clockIn.value = false;
      Clock_Out.value = false;
      statusAbsen.value = "Belum absen";
      print("Masuk kondisi 1");
      return;
    } else if (absence['clock_in'] != null && absence['clock_out'] == null) {
      statusAbsen.value = "Sudah clockIn, belum clock out";
      clockIn.value = true;
      print("Masuk kondisi 2");
    } else {
      clockIn.value = true;
      Clock_Out.value = true;
      statusAbsen.value = "Sudah absen dan clock out";
      print("Masuk kondisi 3");
    }
  }

  Future<String> checkTime() async {
    final userId = supabase.auth.currentSession?.user.id;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('HH:mm:ss').format(now);

    if (userId == null) throw Exception("User tidak login");

    final user = await supabase
        .from('users')
        .select('office_id')
        .eq('id', userId)
        .maybeSingle();

    final officeId = user?['office_id'];
    print(officeId);

    print(formattedDate);

    final supabaseJam = await supabase
        .from('work_schedules')
        .select('start_time')
        .eq('office_id', officeId)
        .maybeSingle();
    print("ini jam : $supabaseJam");
    if (supabaseJam == null) throw Exception("Jam kerja tidak ada");

    final startTime = supabaseJam['start_time'];

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
      return "telat";
    }
    return "alfa";
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
        final response = await supabase.from('absences').insert({
          'user_id': userId,
          'date': today,
          'status': status,
          'clock_in': DateTime.now().toIso8601String().split("T")[1],
        });

        print(response);
        clockIn.value = true;
      }
    } catch (e) {
      print("ERROR CLOCK IN: $e");
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> clockOutAbsence() async {
    try {
      final user = supabase.auth.currentUser!.id;
      final today = DateTime.now().toIso8601String().split("T")[0];

      final response = await supabase
          .from('absences')
          .update({'clock_out': DateTime.now().toIso8601String().split("T")[1]})
          .eq('user_id', user)
          .eq('date', today);
      print(response);
      if (response != null) {
        Clock_Out.value = true;
      }
    } catch (e) {
      Get.snackbar("Error", "Anda sudah absen hari ini");
    } finally {}
  }

  Future<Map<String, dynamic>> getOffice() async {
    final session = supabase.auth.currentSession;
    final userId = session?.user.id;

    if (userId == null) {
      Get.snackbar("Error", "User not login");
      throw Exception("Error");
    }

    final user = await supabase
        .from("users")
        .select("office_id")
        .eq("id", userId)
        .maybeSingle();

    print("user row => $user");
    print("office id => ${user?['office_id']}");

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
        todayAbsence['clockn'] != null &&
        todayAbsence['clock_out'] != null) {
      Get.snackbar("Error", "Hari ini sudah absen");
      return;
    }

    final position = await getCurrentLocation();
    final office = await getOffice();

    final distance = calculateDistance(
      position.latitude,
      position.longitude,
      office['latitude'],
      office['longitude'],
    );

    if (distance > office['radius']) {
      Get.snackbar("Error", "Gagal absen, di luar area kantor ($distance m)");
      return;
    }

    if (todayAbsence == null) {
      await clockInAbsence();
      Get.snackbar("Sukses", "Berhasil clock in");
      await fetchAbsence();
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
      final response = await supabase
          .from('absences')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
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
