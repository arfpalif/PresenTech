import 'package:get/get.dart';
import 'package:presentech/features/employee/homepage/controller/navigation_controller.dart';
import 'package:presentech/features/employee/settings/controller/employee_setting_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NavigationController(), permanent: true);

    // You can add other controllers or services here that need to be initialized at app start

    // EmployeeSettingController akan di-lazyPut dari BottomNav
  }
}
