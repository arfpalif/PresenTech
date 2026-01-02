import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/hrd/location/controller/location_controller.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/features/hrd/location/view/components/hrd_location_list.dart';
import 'package:presentech/shared/view/themes/themes.dart';

class HrdLocation extends GetView<LocationController> {
  const HrdLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "location page",
          style: AppTextStyle.heading1.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[AppColors.colorPrimary, AppColors.colorSecondary],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.colorSecondary,
        onPressed: () {
          Get.toNamed(Routes.hrdAddLocation);
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(children: [HrdLocationList()]),
        ),
      ),
    );
  }
}
