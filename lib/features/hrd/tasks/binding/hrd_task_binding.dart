import 'package:get/get.dart';
import 'package:presentech/features/hrd/tasks/controller/hrd_task_controller.dart';
import 'package:presentech/shared/controllers/date_controller.dart';

class HrdTaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HrdTaskController());
    Get.lazyPut(() => DateController());
  }
}
