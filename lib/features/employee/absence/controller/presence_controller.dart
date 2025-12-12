import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:presentech/features/employee/absence/model/absence.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PresenceController extends GetxController {
  final supabase = Supabase.instance.client;
  var ClockIn = false.obs;
  var ClockOut = false.obs;
  var statusAbsen = "".obs;

  RxList<Absence> absences = <Absence>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkTodayAbsence();
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
      ClockIn = false.obs;
      ClockOut = false.obs;
      statusAbsen.value = "Belum absen";
      return;
    } else if (absence['clock_in'] != null && absence['clock_out'] == null) {
      statusAbsen.value = "Sudah clockIn, belum clock out";
    } else {
      ClockIn.value == absence['clock_in'];
      ClockOut.value == absence['clock_out'];
      statusAbsen.value = "Sudah absen dan clock out";
    }
  }

  Future<void> checkTime() async {
    final userId = supabase.auth.currentSession?.user.id;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss').format(now);

    if (userId == null) {
      print("User tidak login");
      return;
    }
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
        .select('start_time, end_time')
        .eq('office_id', officeId)
        .maybeSingle();
    print("ini jam : $supabaseJam");
  }

  Future<void> clockIn() async {
    try {
      final userId = supabase.auth.currentUser!.id;

      final response = await supabase.from('absences').insert({
        'user_id': userId,
        'clock_in': DateTime.now().toIso8601String().split("T")[1],
      });

      print(response);
      ClockIn.value = true;
    } catch (e) {
      print("ERROR CLOCK IN: $e");
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> clockOut() async {
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
        ClockOut.value = true;
      }
    } finally {
      ClockIn.value = false;
      ClockOut.value = false;
    }
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
    final position = await getCurrentLocation();
    final userLat = position.latitude;
    final userLong = position.longitude;
    final office = await getOffice();

    final officeLat = office['latitude'];
    final officeLong = office['longitude'];
    final officeRadius = office['radius'];

    final distance = calculateDistance(
      userLat,
      userLong,
      officeLat,
      officeLong,
    );
    if (distance <= officeRadius) {
      if (ClockIn.value == false) {
        await clockIn();
        Get.snackbar("Sukses", "Berhasil absen dari jarak : $distance m");
        return;
      } else if (ClockOut.value == false) {
        await clockOut();
        Get.snackbar("Sukses", "Berhasil clock out");
        return;
      } else if (ClockOut.value == true && ClockIn.value == true) {
        Get.snackbar("Error", "Hari ini sudah absen");
      }
    } else if (ClockOut.value == true && ClockIn.value == true) {
      Get.snackbar("Error", "Hari ini sudah absen");
    } else {
      Get.snackbar(
        "Error",
        "Gagal absen lokasi kantor di $officeLong $officeLat dengan jarak $distance m",
      );
    }
  }

  Future<void> fetchAbsence() async {
    try {
      final response = await supabase
          .from('absences')
          .select()
          .order('id', ascending: false);

      absences.value = response
          .map<Absence>((item) => Absence.fromJson(item))
          .toList();
    } catch (e) {
      print("Error fetch Absence: $e");
    } finally {}
  }
}
