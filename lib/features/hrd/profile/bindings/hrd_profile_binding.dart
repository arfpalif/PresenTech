import 'package:get/instance_manager.dart';
import 'package:presentech/shared/controllers/auth_controller.dart';
import 'package:presentech/features/hrd/profile/controllers/hrd_profile_controller.dart';

class HrdProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.lazyPut(() => HrdProfileController());
  }
}
