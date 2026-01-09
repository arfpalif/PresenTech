import 'package:get/get.dart';
import 'package:presentech/features/hrd/location/controller/add_location_controller.dart';
import 'package:presentech/features/hrd/location/controller/location_controller.dart';

class HrdAddLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddLocationController());
    Get.lazyPut(() => LocationController());
  }
}
