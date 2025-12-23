import 'package:get/get.dart';
import 'package:presentech/features/hrd/permission/controller/hrd_permission_controller.dart';

class HrdPermissionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HrdPermissionController());
  }
}
