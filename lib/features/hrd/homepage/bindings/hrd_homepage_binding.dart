import 'package:get/get.dart';
import 'package:presentech/features/hrd/attendance/controller/hrd_attendance_controller.dart';
import 'package:presentech/features/hrd/homepage/controller/hrd_homepage_controller.dart';
import 'package:presentech/features/hrd/tasks/controller/hrd_task_controller.dart';

class HrdHomepageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HrdHomepageController());
    Get.lazyPut(() => HrdAttendanceController());
    Get.lazyPut(() => HrdTaskController(), fenix: true);
  }
}
