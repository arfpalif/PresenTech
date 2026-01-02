import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/features/hrd/location/controller/location_controller.dart';
import 'package:presentech/shared/view/themes/themes.dart';

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
              Icon(Icons.location_off, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                "Belum ada lokasi",
                style: AppTextStyle.heading2.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                "Tekan tombol refresh untuk memuat data",
                style: AppTextStyle.normal.copyWith(color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  controller.fetchOffices();
                },
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
          return Card(
            shadowColor: Colors.transparent,
            color: AppColors.greyprimary,
            margin: const EdgeInsets.only(bottom: 15),
            child: ListTile(
              onTap: () {
                Get.toNamed(Routes.hrdLocationDetail, arguments: office);
              },
              contentPadding: const EdgeInsets.all(10),
              title: Text(
                office.name,
                style: AppTextStyle.heading2.copyWith(color: Colors.black),
              ),
              subtitle: Text(
                "${office.address}\nRadius: ${office.radius} meter",
                style: AppTextStyle.normal.copyWith(color: Colors.grey),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Lat: ${office.latitude.toStringAsFixed(4)}",
                    style: AppTextStyle.normal,
                  ),
                  Text(
                    "Lng: ${office.longitude.toStringAsFixed(4)}",
                    style: AppTextStyle.normal,
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
