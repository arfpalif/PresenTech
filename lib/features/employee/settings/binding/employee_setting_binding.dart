import 'package:get/get.dart';
import 'package:presentech/features/employee/settings/controller/employee_setting_controller.dart';

class EmployeeSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EmployeeSettingController());
  }
}
