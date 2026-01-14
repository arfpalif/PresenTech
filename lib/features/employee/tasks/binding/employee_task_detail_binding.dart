import 'package:get/get.dart';
import 'package:presentech/features/employee/tasks/controller/employee_task_controller.dart';
import 'package:presentech/features/employee/tasks/controller/employee_task_detail_controller.dart';
import 'package:presentech/shared/controllers/date_controller.dart';

class EmployeeTaskDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EmployeeTaskController());
    Get.lazyPut(() => EmployeeTaskDetailController());
    Get.lazyPut(() => DateController());
  }
}
