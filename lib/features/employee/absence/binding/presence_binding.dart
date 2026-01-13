import 'package:get/get.dart';
import 'package:presentech/features/employee/absence/controllers/presence_controller.dart';

class PresenceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PresenceController());
  }
}
