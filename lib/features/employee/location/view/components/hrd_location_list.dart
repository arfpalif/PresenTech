import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/features/hrd/location/controller/location_controller.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/shared/styles/color_style.dart';

class HrdLocationList extends GetView<LocationController> {
  const HrdLocationList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.offices.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Icon(Icons.location_off, size: 60, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text(
                "No location found",
                style: AppTextStyle.heading2.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                "Tap refresh to load data",
                style: AppTextStyle.normal.copyWith(color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  controller.fetchOffices();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorStyle.colorPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                icon: const Icon(Icons.refresh),
                label: const Text("Refresh"),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        itemCount: controller.offices.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final office = controller.offices[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: ListTile(
              onTap: () {
                Get.toNamed(Routes.hrdLocationDetail, arguments: office);
              },
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ColorStyle.colorPrimary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.location_on, color: ColorStyle.colorPrimary),
              ),
              title: Text(
                office.name,
                style: AppTextStyle.heading2.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      office.address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.normal.copyWith(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Radius: ${office.radius} m",
                      style: AppTextStyle.smallText.copyWith(color: ColorStyle.greenPrimary, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
            ),
          );
        },
      );
    });
  }
}
