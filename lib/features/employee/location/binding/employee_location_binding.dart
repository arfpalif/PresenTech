import 'package:get/get.dart';
import 'package:presentech/features/employee/location/controller/location_controller.dart';

class EmployeeLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LocationController());
  }
}
