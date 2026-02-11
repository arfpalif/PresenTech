import 'package:get/get.dart';
import 'package:presentech/features/auth/login/bindings/login_binding.dart';
import 'package:presentech/features/auth/login/view/ui/login_page.dart';
import 'package:presentech/features/auth/onBoarding/bindings/on_boarding_binding.dart';
import 'package:presentech/features/auth/onBoarding/views/ui/on_boarding_page.dart';
import 'package:presentech/features/auth/register/bindings/register_binding.dart';
import 'package:presentech/features/auth/register/view/ui/register_page.dart';
import 'package:presentech/features/auth/splash/bindings/splash_binding.dart';
import 'package:presentech/features/auth/splash/view/splash_screen.dart';
import 'package:presentech/features/employee/absence/binding/presence_binding.dart';
import 'package:presentech/features/employee/absence/views/ui/absence_widget.dart';
import 'package:presentech/features/employee/homepage/bindings/employee_homepage_binding.dart';
import 'package:presentech/features/employee/homepage/view/ui/employee_homepage.dart';
import 'package:presentech/features/employee/location/binding/employee_location_binding.dart';
import 'package:presentech/features/employee/location/view/ui/employee_location_page.dart';
import 'package:presentech/features/employee/permissions/bindings/employee_permissions_binding.dart';
import 'package:presentech/features/employee/permissions/view/ui/employee_add_permission.dart';
import 'package:presentech/features/employee/permissions/view/ui/employee_permission.dart';
import 'package:presentech/features/employee/permissions/view/ui/employee_permission_detail.dart';
import 'package:presentech/features/employee/profile/view/ui/profile.dart';
import 'package:presentech/features/employee/settings/view/ui/employee_settings.dart';
import 'package:presentech/features/employee/tasks/binding/employee_task_binding.dart';
import 'package:presentech/features/employee/tasks/view/ui/employee_add_task.dart';
import 'package:presentech/features/employee/tasks/view/ui/employee_task.dart';
import 'package:presentech/features/employee/tasks/view/ui/employee_task_detail.dart';
import 'package:presentech/features/employee/tasks/binding/employee_task_detail_binding.dart';
import 'package:presentech/features/hrd/attendance/binding/hrd_attendance_binding.dart';
import 'package:presentech/features/hrd/attendance/view/ui/hrd_attedance.dart';
import 'package:presentech/features/hrd/employee/binding/hrd_employee_binding.dart';
import 'package:presentech/features/hrd/employee/binding/hrd_employee_detail_binding.dart';
import 'package:presentech/features/hrd/employee/view/ui/hrd_employee.dart';
import 'package:presentech/features/hrd/employee/view/ui/hrd_employee_detail.dart';
import 'package:presentech/features/hrd/homepage/bindings/hrd_homepage_binding.dart';
import 'package:presentech/features/hrd/homepage/view/ui/hrd_homepage.dart';
import 'package:presentech/features/hrd/location/binding/hrd_add_location_binding.dart';
import 'package:presentech/features/hrd/location/binding/hrd_location_binding.dart';
import 'package:presentech/features/hrd/location/binding/hrd_location_detail_binding.dart';
import 'package:presentech/features/hrd/location/view/ui/hrd_add_location.dart';
import 'package:presentech/features/hrd/location/view/ui/hrd_location.dart';
import 'package:presentech/features/hrd/location/view/ui/hrd_location_detail.dart';
import 'package:presentech/features/hrd/permission/binding/hrd_permission_binding.dart';
import 'package:presentech/features/hrd/permission/binding/hrd_permission_detail_binding.dart';
import 'package:presentech/features/hrd/permission/view/ui/hrd_permission.dart';
import 'package:presentech/features/hrd/permission/view/ui/hrd_permission_detail.dart';
import 'package:presentech/features/hrd/profile/bindings/hrd_profile_binding.dart';
import 'package:presentech/features/hrd/profile/view/ui/hrd_profile_page.dart';
import 'package:presentech/features/hrd/tasks/binding/hrd_task_binding.dart';
import 'package:presentech/features/hrd/tasks/views/ui/hrd_task_detail.dart';
import 'package:presentech/features/hrd/tasks/views/components/hrd_task_list.dart';
import 'package:presentech/features/hrd/tasks/views/ui/hrd_task_today.dart';
import 'package:presentech/shared/bindings/employee_nav_binding.dart';
import 'package:presentech/shared/bindings/hrd_nav_binding.dart';
import 'package:presentech/shared/bindings/profile_binding.dart';
import 'package:presentech/shared/view/ui/coming_soon.dart';
import 'package:presentech/shared/view/widgets/employee_bottom_nav.dart';
import 'package:presentech/shared/view/widgets/hrd_bottom_nav.dart';
import '../routes/app_routes.dart';

class AppPages {
  static final pages = [
    // <!-- Auth Pages -->
    GetPage(
      name: Routes.login,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.register,
      page: () => RegisterPage(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.splash,
      page: () => SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.onBoarding,
      page: () => OnBoardingPage(),
      binding: OnBoardingBinding(),
    ),

    //Coming soon
    GetPage(name: Routes.comingSoon, page: () => ComingSoon()),

    //Navbar
    GetPage(
      name: Routes.employeeNavbar,
      page: () => EmployeeBottomNav(),
      binding: EmployeeNavBinding(),
    ),
    GetPage(
      name: Routes.hrdNavbar,
      page: () => HrdBottomNav(),
      binding: HrdNavBinding(),
    ),

    // <!-- Employee Pages -->
    GetPage(
      name: Routes.employeeHome,
      page: () => EmployeeHomepage(),
      binding: EmployeeHomepageBinding(),
    ),
    GetPage(
      name: Routes.employeeAbsenceHistory,
      page: () => AbsenceWidget(),
      binding: PresenceBinding(),
    ),
    GetPage(
      name: Routes.employeeIzin,
      page: () => EmployeePermission(),
      binding: EmployeePermissionsBinding(),
    ),
    GetPage(
      name: Routes.employeePermissionAdd,
      page: () => EmployeeAddPermission(),
      binding: EmployeePermissionsBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.employeePermissionDetail,
      page: () => EmployeePermissionDetail(),
      binding: EmployeePermissionsBinding(),
    ),
    GetPage(
      name: Routes.employeeTugas,
      page: () => EmployeeTask(),
      binding: EmployeeTaskBinding(),
    ),
    GetPage(
      name: Routes.employeeTaskAdd,
      page: () => EmployeeAddTask(),
      binding: EmployeeTaskBinding(),
    ),
    GetPage(
      name: Routes.employeeTaskDetail,
      page: () => EmployeeTaskDetail(),
      binding: EmployeeTaskDetailBinding(),
    ),
    GetPage(
      name: Routes.employeeProfile,
      page: () => Profile(),
      binding: ProfileBinding(),
    ),

    GetPage(
      name: Routes.employeeSettings,
      page: () => EmployeeSettings(),
      binding: ProfileBinding(),
    ),

    GetPage(
      name: Routes.employeeLocation,
      page: () => EmployeeLocationPage(),
      binding: EmployeeLocationBinding(),
    ),

    //<!-- HRD Pages -->
    GetPage(
      name: Routes.hrdHome,
      page: () => HrdHomepage(),
      binding: HrdHomepageBinding(),
    ),
    GetPage(
      name: Routes.hrdAbsen,
      page: () => HrdAttedance(),
      binding: HrdAttendanceBinding(),
    ),
    GetPage(
      name: Routes.hrdApproval,
      page: () => HrdPermission(),
      binding: HrdPermissionBinding(),
    ),
    GetPage(
      name: Routes.hrdPermissionDetail,
      page: () => HrdPermissionDetail(),
      binding: HrdPermissionDetailBinding(),
    ),
    GetPage(
      name: Routes.hrdLocation,
      page: () => const HrdLocation(),
      binding: HrdLocationBinding(),
    ),
    GetPage(
      name: Routes.hrdProfile,
      page: () => HrdProfilePage(),
      binding: HrdProfileBinding(),
    ),
    GetPage(
      name: Routes.hrdLocationDetail,
      page: () => HrdLocationDetail(),
      binding: HrdLocationDetailBinding(),
    ),
    GetPage(
      name: Routes.hrdTask,
      page: () => HrdTaskList(),
      binding: HrdTaskBinding(),
    ),
    GetPage(
      name: Routes.hrdTaskDetail,
      page: () => HrdTaskDetail(),
      binding: HrdTaskBinding(),
    ),
    GetPage(
      name: Routes.hrdTaskToday,
      page: () => HrdTaskToday(),
      binding: HrdTaskBinding(),
    ),
    GetPage(
      name: Routes.hrdEmployee,
      page: () => HrdEmployee(),
      binding: HrdEmployeeBinding(),
    ),
    GetPage(
      name: Routes.hrdEmployeeDetail,
      page: () => HrdEmployeeDetail(),
      binding: HrdEmployeeDetailBinding(),
    ),
    GetPage(
      name: Routes.hrdAddLocation,
      page: () => HrdAddLocation(),
      binding: HrdAddLocationBinding(),
    ),
  ];
}
