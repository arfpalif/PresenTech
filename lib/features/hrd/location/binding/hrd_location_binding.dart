import 'package:get/get.dart';
import 'package:presentech/features/hrd/location/controller/location_controller.dart';

class HrdLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LocationController());
  }
}
