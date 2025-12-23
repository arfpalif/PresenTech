import 'package:get/get.dart';
import 'package:presentech/features/employee/settings/controller/employee_setting_controller.dart';

class NavigationController extends GetxController {
  var currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
    
    // Refresh data saat tab Settings dibuka (index 3)
    if (index == 3) {
      if (Get.isRegistered<EmployeeSettingController>()) {
        Get.find<EmployeeSettingController>().getUserProfile();
      }
    }
  }
}