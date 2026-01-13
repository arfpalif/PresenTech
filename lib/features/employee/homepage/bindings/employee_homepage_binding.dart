import 'package:get/get.dart';
import 'package:presentech/features/employee/absence/controllers/presence_controller.dart';
import 'package:presentech/features/employee/homepage/controllers/employee_homepage_controller.dart';
import 'package:presentech/features/employee/tasks/controller/employee_task_controller.dart';
import 'package:presentech/shared/controllers/profile_controller.dart';

class EmployeeHomepageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EmployeeHomepageController());
    Get.lazyPut(() => PresenceController());
    Get.lazyPut(() => EmployeeTaskController());
    Get.lazyPut(() => ProfileController());
  }
}
