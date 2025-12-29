import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/auth/controller/auth_controller.dart';
import 'package:presentech/features/auth/view/register_pages.dart';
import 'package:presentech/shared/view/widgets/employee_bottom_nav.dart';
import 'package:presentech/shared/view/widgets/hrd_bottom_nav.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();

    return Obx(() {
      if (authC.isLoading.value) {
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        if (authC.role.value.toLowerCase() == 'hrd') {
          return HrdBottomNav();
        } else {
          return EmployeeBottomNav();
        }
      } else {
        return RegisterPages();
      }
    });

    // return StreamBuilder(
    //   stream: Supabase.instance.client.auth.onAuthStateChange,

    //   builder: (context, snapshot){
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return Scaffold(
    //         body: Center(
    //           child: CircularProgressIndicator(),
    //         ),
    //       );
    //     }
    //     final session = Supabase.instance.client.auth.currentSession;

    //     if(session != null){
    //       return AuthGate();
    //     }
    //     else {
    //       return RegisterPages();
    //     }
    //   },
    // );
  }
}
