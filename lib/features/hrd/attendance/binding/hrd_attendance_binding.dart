import 'package:get/get.dart';
import 'package:presentech/features/hrd/attendance/controller/hrd_attendance_controller.dart';

class HrdAttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HrdAttendanceController());
  }
}
