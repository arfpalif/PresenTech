import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/controller/auth_controller.dart';
import 'package:presentech/views/pages/Employee/homepages.dart';
import 'package:presentech/views/pages/HR/Homepage.dart';
import 'package:presentech/views/pages/register_pages.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();

    return Obx((){
      if(authC.isLoading.value){
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (authC.role.value == 'none'){
        return RegisterPages();
      }

      if(authC.role.value == 'hrd'){
        return HrdHomepage();
      }
      return UserHomepages();
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
    //       return UserHomepages();
    //     }
    //     else {
    //       return RegisterPages();
    //     }
    //   },
    // );
  }
}