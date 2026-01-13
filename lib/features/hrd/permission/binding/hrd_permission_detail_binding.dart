import 'package:get/get.dart';
import 'package:presentech/features/hrd/permission/controller/hrd_permission_controller.dart';
import 'package:presentech/features/hrd/permission/controller/hrd_permission_detail_controller.dart';

class HrdPermissionDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HrdPermissionController(), fenix: true);
    Get.lazyPut(() => HrdPermissionDetailController());
  }
}
