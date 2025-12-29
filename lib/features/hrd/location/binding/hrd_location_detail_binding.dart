import 'package:get/get.dart';
import 'package:presentech/features/hrd/location/controller/detail_location_controller.dart';

class HrdLocationDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DetailLocationController());
  }
}
