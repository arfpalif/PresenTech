import 'package:get/get.dart';
// AuthController is registered in main.dart; no direct import needed here
import 'package:presentech/features/employee/homepage/view/employee_homepage.dart';
import 'package:presentech/features/employee/permissions/view/employee_permission.dart';
import 'package:presentech/features/employee/settings/binding/employee_setting_binding.dart';
import 'package:presentech/features/employee/settings/view/employee_settings.dart';
import 'package:presentech/features/employee/tasks/binding/employee_task_binding.dart';
import 'package:presentech/features/employee/tasks/view/employee_task.dart';
import 'package:presentech/features/hrd/attendance/view/hrd_attedance.dart';
import 'package:presentech/features/hrd/homepage/view/hrd_homepage.dart';
import 'package:presentech/features/hrd/location/binding/hrd_location_binding.dart';
import 'package:presentech/features/hrd/location/view/hrd_location.dart';
import 'package:presentech/features/hrd/permission/binding/hrd_permission_binding.dart';
import 'package:presentech/features/hrd/permission/view/hrd_permission.dart';
import 'package:presentech/features/employee/auth/view/loginpage.dart';
import 'package:presentech/features/employee/auth/view/register_pages.dart';
import 'package:presentech/features/hrd/profile/bindings/hrd_profile_binding.dart';
import 'package:presentech/features/hrd/profile/view/hrd_profile_page.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.LOGIN,
      page: () => Loginpage(),
      binding: BindingsBuilder(() {}),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterPages(),
      binding: BindingsBuilder(() {}),
    ),

    GetPage(
      name: Routes.employee_home,
      page: () => EmployeeHomepage(),
      binding: BindingsBuilder(() {}),
    ),
    GetPage(
      name: Routes.employee_izin,
      page: () => EmployeePermission(),
      binding: BindingsBuilder(() {}),
    ),
    GetPage(
      name: Routes.employee_tugas,
      page: () => EmployeeTask(),
      binding: EmployeeTaskBinding(),
    ),

    GetPage(
      name: Routes.employee_settings,
      page: () => const EmployeeSettings(),
      binding: EmployeeSettingBinding(),
    ),

    GetPage(
      name: Routes.HRD_HOME,
      page: () => HrdHomepage(),
      binding: BindingsBuilder(() {}),
    ),
    GetPage(
      name: Routes.HRD_APPROVAL,
      page: () => HrdPermission(),
      binding: HrdPermissionBinding(),
    ),
    GetPage(
      name: Routes.HRD_ABSEN,
      page: () => HrdAttedance(),
      binding: BindingsBuilder(() {}),
    ),
    GetPage(
      name: Routes.hrd_location,
      page: () => const HrdLocation(),
      binding: HrdLocationBinding(),
    ),
    GetPage(
      name: Routes.hrd_profile,
      page: () => HrdProfilePage(),
      binding: HrdProfileBinding(),
    ),
  ];
}
