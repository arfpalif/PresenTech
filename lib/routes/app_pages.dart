import 'package:get/get.dart';
import 'package:presentech/controllers/auth_controller.dart';
import 'package:presentech/views/pages/employee/employee_homepage.dart';
import 'package:presentech/views/pages/employee/employee_permission.dart';
import 'package:presentech/views/pages/employee/employee_task.dart';
import 'package:presentech/views/pages/hrd/hrd_attedance.dart';
import 'package:presentech/views/pages/hrd/hrd_homepage.dart';
import 'package:presentech/views/pages/hrd/hrd_permission.dart';
import 'package:presentech/views/pages/loginpage.dart';
import 'package:presentech/views/pages/register_pages.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [

    GetPage(
      name: Routes.LOGIN,
      page: () => Loginpage(),
      binding: BindingsBuilder((){
        Get.put(AuthController());
      }),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterPages(),
      binding: BindingsBuilder((){
        Get.put(AuthController());
      }),
    ),

    GetPage(
      name: Routes.employee_home,
      page: () => EmployeeHomepage(),
      binding: BindingsBuilder((){

      }),
    ),
    
    GetPage(
      name: Routes.employee_izin,
      page: () => EmployeePermission(),
      binding: BindingsBuilder((){
        
      }),
    ),
    GetPage(
      name: Routes.employee_tugas,
      page: () => EmployeeTask(),
      binding: BindingsBuilder((){
        
      }),
    ),

    GetPage(
      name: Routes.HRD_HOME,
      page: () => HrdHomepage(),
      binding: BindingsBuilder((){

      }),
    ),
    GetPage(
      name: Routes.HRD_APPROVAL,
      page: () => HrdPermission(),
      binding: BindingsBuilder((){
        
      }),
    ),
    GetPage(
      name: Routes.HRD_ABSEN,
      page: () => HrdAttedance(),
      binding: BindingsBuilder((){
        
      }),
    ),
  ];
}
