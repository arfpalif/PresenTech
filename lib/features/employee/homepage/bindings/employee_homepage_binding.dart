import 'package:get/get.dart';
import 'package:presentech/features/employee/absence/controller/presence_controller.dart';
import 'package:presentech/features/employee/homepage/controllers/employee_homepage_controller.dart';
import 'package:presentech/features/employee/tasks/controller/employee_task_controller.dart';

class EmployeeHomepageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(EmployeeHomepageController());
    Get.put(PresenceController());
    Get.put(EmployeeTaskController());
  }
}
