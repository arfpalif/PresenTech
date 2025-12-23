import 'package:get/get.dart';
import 'package:presentech/features/employee/tasks/controller/employee_task_controller.dart';

class EmployeeTaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EmployeeTaskController());
  }
}
