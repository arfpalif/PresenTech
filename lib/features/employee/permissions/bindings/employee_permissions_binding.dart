import 'package:get/get.dart';
import 'package:presentech/features/employee/permissions/controller/employee_permission_controller.dart';
import 'package:presentech/shared/controllers/date_controller.dart';

class EmployeePermissionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DateController());
    Get.lazyPut(() => EmployeePermissionController());
  }
}
