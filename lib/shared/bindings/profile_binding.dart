import 'package:get/get.dart';
import 'package:presentech/shared/controllers/date_controller.dart';
import 'package:presentech/shared/controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => DateController());
  }
}
