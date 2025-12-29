import 'package:get/get.dart';
import 'package:presentech/features/auth/view/loginpage.dart';
import 'package:presentech/features/auth/view/register_pages.dart';
import 'package:presentech/features/employee/absence/binding/presence_binding.dart';
import 'package:presentech/features/employee/absence/view/absence_list.dart';
import 'package:presentech/features/employee/homepage/bindings/employee_homepage_binding.dart';
import 'package:presentech/features/employee/homepage/view/ui/employee_homepage.dart';
import 'package:presentech/features/employee/permissions/bindings/employee_permissions_binding.dart';
import 'package:presentech/features/employee/permissions/view/employee_add_permission.dart';
import 'package:presentech/features/employee/permissions/view/employee_permission.dart';
import 'package:presentech/features/employee/permissions/view/employee_permission_detail.dart';
import 'package:presentech/features/employee/profile/binding/profile_binding.dart';
import 'package:presentech/features/employee/profile/view/profile_page.dart';
import 'package:presentech/features/employee/settings/binding/employee_setting_binding.dart';
import 'package:presentech/features/employee/settings/view/ui/employee_settings.dart';
import 'package:presentech/features/employee/tasks/binding/employee_task_binding.dart';
import 'package:presentech/features/employee/tasks/view/employee_add_task.dart';
import 'package:presentech/features/employee/tasks/view/employee_task.dart';
import 'package:presentech/features/employee/tasks/view/employee_task_detail.dart';
import 'package:presentech/features/hrd/attendance/binding/hrd_attendance_binding.dart';
import 'package:presentech/features/hrd/attendance/view/hrd_attedance.dart';
import 'package:presentech/features/hrd/employee/binding/hrd_employee_binding.dart';
import 'package:presentech/features/hrd/employee/binding/hrd_employee_detail_binding.dart';
import 'package:presentech/features/hrd/employee/view/hrd_employee.dart';
import 'package:presentech/features/hrd/employee/view/hrd_employee_detail.dart';
import 'package:presentech/features/hrd/homepage/view/hrd_homepage.dart';
import 'package:presentech/features/hrd/location/binding/hrd_add_location_binding.dart';
import 'package:presentech/features/hrd/location/binding/hrd_location_binding.dart';
import 'package:presentech/features/hrd/location/binding/hrd_location_detail_binding.dart';
import 'package:presentech/features/hrd/location/view/hrd_add_location.dart';
import 'package:presentech/features/hrd/location/view/hrd_location.dart';
import 'package:presentech/features/hrd/location/view/hrd_location_detail.dart';
import 'package:presentech/features/hrd/permission/binding/hrd_permission_binding.dart';
import 'package:presentech/features/hrd/permission/view/hrd_permission.dart';
import 'package:presentech/features/hrd/profile/bindings/hrd_profile_binding.dart';
import 'package:presentech/features/hrd/profile/view/hrd_profile_page.dart';
import 'package:presentech/features/hrd/tasks/binding/hrd_task_binding.dart';
import 'package:presentech/features/hrd/tasks/views/hrd_task_detail.dart';
import 'package:presentech/features/hrd/tasks/views/hrd_task_list.dart';
import '../routes/app_routes.dart';

class AppPages {
  static final pages = [
    // <!-- Auth Pages -->
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

    // <!-- Employee Pages -->
    GetPage(
      name: Routes.employee_home,
      page: () => EmployeeHomepage(),
      binding: EmployeeHomepageBinding(),
    ),
    GetPage(
      name: Routes.employee_absence_history,
      page: () => AbsenceList(),
      binding: PresenceBinding(),
    ),
    GetPage(
      name: Routes.employee_izin,
      page: () => EmployeePermission(),
      binding: EmployeePermissionsBinding(),
    ),
    GetPage(
      name: Routes.employee_permission_add,
      page: () => EmployeeAddPermission(),
      binding: EmployeePermissionsBinding(),
    ),
    GetPage(
      name: Routes.employee_permission_detail,
      page: () => EmployeePermissionDetail(),
      binding: EmployeePermissionsBinding(),
    ),
    GetPage(
      name: Routes.employee_tugas,
      page: () => EmployeeTask(),
      binding: EmployeeTaskBinding(),
    ),
    GetPage(
      name: Routes.employee_task_add,
      page: () => EmployeeAddTask(),
      binding: EmployeeTaskBinding(),
    ),
    GetPage(
      name: Routes.employee_task_detail,
      page: () => EmployeeTaskDetail(),
      binding: EmployeeTaskBinding(),
    ),
    GetPage(
      name: Routes.employee_profile,
      page: () => const ProfilePage(),
      binding: ProfileBinding(),
    ),

    GetPage(
      name: Routes.employee_settings,
      page: () => const EmployeeSettings(),
      binding: EmployeeSettingBinding(),
    ),

    //<!-- HRD Pages -->
    GetPage(
      name: Routes.HRD_HOME,
      page: () => HrdHomepage(),
      binding: BindingsBuilder(() {}),
    ),
    GetPage(
      name: Routes.HRD_ABSEN,
      page: () => HrdAttedance(),
      binding: HrdAttendanceBinding(),
    ),
    GetPage(
      name: Routes.HRD_APPROVAL,
      page: () => HrdPermission(),
      binding: HrdPermissionBinding(),
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
    GetPage(
      name: Routes.hrd_location_detail,
      page: () => HrdLocationDetail(),
      binding: HrdLocationDetailBinding(),
    ),
    GetPage(
      name: Routes.hrd_tasks,
      page: () => HrdTaskList(),
      binding: HrdTaskBinding(),
    ),
    GetPage(
      name: Routes.hrd_task_detail,
      page: () => HrdTaskDetail(),
      binding: HrdTaskBinding(),
    ),
    GetPage(
      name: Routes.hrd_employee,
      page: () => const HrdEmployee(),
      binding: HrdEmployeeBinding(),
    ),
    GetPage(
      name: Routes.hrd_employee_detail,
      page: () => HrdEmployeeDetail(),
      binding: HrdEmployeeDetailBinding(),
    ),
    GetPage(
      name: Routes.hrd_add_location,
      page: () => HrdAddLocation(),
      binding: HrdAddLocationBinding(),
    ),
  ];
}
