import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/hrd/location/controller/location_controller.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/features/hrd/location/view/components/hrd_location_list.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/shared/styles/color_style.dart';

class HrdLocation extends GetView<LocationController> {
  const HrdLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          "Office Locations",
          style: AppTextStyle.heading1.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                ColorStyle.colorPrimary,
                ColorStyle.greenPrimary,
              ],
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: ColorStyle.greenPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () {
          Get.toNamed(Routes.hrdAddLocation);
        },
        child: const Icon(Icons.add_rounded, size: 30),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(children: [HrdLocationList()]),
        ),
      ),
    );
  }
}
