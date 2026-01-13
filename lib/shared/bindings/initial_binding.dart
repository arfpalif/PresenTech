import 'package:get/get.dart';
import 'package:presentech/shared/controllers/auth_controller.dart';
import 'package:presentech/shared/controllers/date_controller.dart';
import 'package:presentech/shared/controllers/navigation_controller.dart';
import 'package:presentech/utils/services/image_picker_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NavigationController(), fenix: true);
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => DateController(), fenix: true);
    Get.lazyPut(() => ImagePickerService(), fenix: true);
  }
}
