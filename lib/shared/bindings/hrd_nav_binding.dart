import 'package:get/get.dart';
import 'package:presentech/features/hrd/attendance/controller/hrd_attendance_controller.dart';
import 'package:presentech/features/hrd/employee/controller/hrd_employee_controller.dart';
import 'package:presentech/features/hrd/homepage/controller/hrd_homepage_controller.dart';
import 'package:presentech/features/hrd/location/controller/location_controller.dart';
import 'package:presentech/features/hrd/permission/controller/hrd_permission_controller.dart';
import 'package:presentech/features/hrd/profile/controllers/hrd_profile_controller.dart';
import 'package:presentech/shared/controllers/navigation_controller.dart';

class HrdNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HrdHomepageController(), fenix: true);
    Get.lazyPut(() => HrdAttendanceController(), fenix: true);
    Get.lazyPut(() => HrdEmployeeController(), fenix: true);
    Get.lazyPut(() => HrdProfileController(), fenix: true);
    Get.lazyPut(() => HrdPermissionController(), fenix: true);
    Get.lazyPut(() => LocationController(), fenix: true);
    Get.lazyPut(() => NavigationController(), fenix: true);
  }
}
