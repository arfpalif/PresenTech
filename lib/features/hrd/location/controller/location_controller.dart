import 'package:get/get.dart';
import 'package:presentech/features/hrd/location/model/office.dart';
import 'package:presentech/features/hrd/location/repositories/hrd_location_repository.dart';
import 'package:presentech/shared/view/components/snackbar/failed_snackbar.dart';
import 'package:presentech/utils/database/dao/location_dao.dart';
import 'package:presentech/utils/services/connectivity_service.dart';

class LocationController extends GetxController {
  final hrdLocationRepo = HrdLocationRepository();
  final connectivityService = Get.find<ConnectivityService>();
  final LocationDao locationDao = Get.find<LocationDao>();

  final isLoading = false.obs;
  final RxList<Office> offices = <Office>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOffices();

    ever(connectivityService.isOnline, (bool isOnline) {
      if (isOnline) {
        hrdLocationRepo.syncPendingLocations().then((_) => fetchOffices());
      }
    });
  }

  Future<void> fetchOffices() async {
    try {
      isLoading.value = true;
      final data = await hrdLocationRepo.fetchOffices();
      offices.assignAll(data);
    } catch (e) {
      print("Error: $e");
      FailedSnackbar.show("Tidak dapat memuat data lokasi: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshOffices() async {
    await fetchOffices();
  }
}
