import 'package:get/get.dart';
import 'package:presentech/features/hrd/employee/controller/hrd_employee_controller.dart';
import 'package:presentech/features/hrd/employee/controller/hrd_employee_detail_controller.dart';

class HrdEmployeeDetailBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<HrdEmployeeController>()) {
      Get.lazyPut(() => HrdEmployeeController(), fenix: true);
    }
    if (!Get.isRegistered<HrdEmployeeDetailController>()) {
      Get.lazyPut(() => HrdEmployeeDetailController());
    }
  }
}
