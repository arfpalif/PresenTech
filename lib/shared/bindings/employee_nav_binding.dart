import 'package:get/get.dart';
import 'package:presentech/features/employee/homepage/controllers/employee_homepage_controller.dart';
import 'package:presentech/features/employee/permissions/controller/employee_permission_controller.dart';
import 'package:presentech/features/employee/settings/controller/employee_setting_controller.dart';
import 'package:presentech/features/employee/tasks/controller/employee_task_controller.dart';
import 'package:presentech/shared/controllers/navigation_controller.dart';

class EmployeeNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EmployeeHomepageController(), fenix: true);
    Get.lazyPut(() => EmployeePermissionController(), fenix: true);
    Get.lazyPut(() => EmployeeSettingController(), fenix: true);
    Get.lazyPut(() => EmployeeTaskController(), fenix: true);
    Get.lazyPut(() => NavigationController(), fenix: true);
  }
}
