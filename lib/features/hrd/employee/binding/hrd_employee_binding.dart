import 'package:get/get.dart';
import 'package:presentech/features/hrd/employee/controller/hrd_employee_controller.dart';

class HrdEmployeeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<HrdEmployeeController>()) {
      Get.lazyPut(() => HrdEmployeeController(), fenix: true);
    }
  }
}
