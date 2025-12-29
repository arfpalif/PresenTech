import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/hrd/location/model/office.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LocationController extends GetxController {
  final isLoading = false.obs;
  final RxList<Office> offices = <Office>[].obs;

  final supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    fetchOffices();
  }

  Future<void> fetchOffices() async {
    try {
      isLoading.value = true;

      final response = await supabase
          .from('offices')
          .select('*')
          .order('id', ascending: true);

      final data = (response as List).map((e) {
        debugPrint("PARSING OFFICE: $e");
        return Office.fromJson(e);
      }).toList();

      offices.assignAll(data);
    } catch (e) {
      Get.snackbar(
        "Error Mengambil Lokasi",
        "Tidak dapat memuat data lokasi: ${e.toString()}",
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh office list
  Future<void> refreshOffices() async {
    await fetchOffices();
  }
}
