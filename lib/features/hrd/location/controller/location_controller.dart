import 'package:get/get.dart';
import 'package:presentech/features/hrd/location/model/office.dart';
import 'package:presentech/features/hrd/location/repositories/hrd_location_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LocationController extends GetxController {
  //repository
  final hrdLocationRepo = HrdLocationRepository();
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

      final response = await hrdLocationRepo.fetchOffices();

      final data = (response as List).map((e) {
        return Office.fromJson(e);
      }).toList();

      offices.assignAll(data);
    } catch (e) {
      print("Error: $e");
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
