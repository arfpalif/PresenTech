import 'package:get/get.dart';
import 'package:presentech/shared/controllers/auth_controller.dart';
import 'package:presentech/shared/controllers/date_controller.dart';
import 'package:presentech/shared/controllers/navigation_controller.dart';
import 'package:presentech/utils/database/dao/absence_dao.dart';
import 'package:presentech/utils/database/dao/hrd/user_dao.dart';
import 'package:presentech/utils/database/dao/permission_dao.dart';
import 'package:presentech/utils/services/connectivity_service.dart';
import 'package:presentech/utils/services/database_service.dart';
import 'package:presentech/utils/database/database.dart';
import 'package:presentech/utils/database/dao/task_dao.dart';
import 'package:presentech/utils/database/dao/profile_dao.dart';
import 'package:presentech/utils/database/dao/location_dao.dart';
import 'package:presentech/utils/services/image_picker_service.dart';

import 'package:presentech/utils/database/dao/auth_dao.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NavigationController(), fenix: true);
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => DateController(), fenix: true);
    Get.lazyPut(() => ImagePickerService(), fenix: true);
    Get.put(ConnectivityService(), permanent: true);
    final db = Get.put(AppDatabase(), permanent: true);
    Get.lazyPut(() => TaskDao(db), fenix: true);
    Get.lazyPut(() => PermissionDao(db), fenix: true);
    Get.lazyPut(() => AbsenceDao(db), fenix: true);
    Get.lazyPut(() => ProfileDao(db), fenix: true);
    Get.lazyPut(() => AuthDao(db), fenix: true);
    Get.lazyPut(() => LocationDao(db), fenix: true);
    Get.lazyPut(() => UserDao(db), fenix: true);
    Get.lazyPut(() => DatabaseService.instance, fenix: true);
  }
}
