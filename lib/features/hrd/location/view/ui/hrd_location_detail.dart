import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:presentech/features/hrd/location/controller/detail_location_controller.dart';
import 'package:presentech/shared/view/themes/themes.dart';

class HrdLocationDetail extends GetView<DetailLocationController> {
  const HrdLocationDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Lokasi",
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 300,
                child: OSMFlutter(
                  osmOption: OSMOption(
                    userTrackingOption: const UserTrackingOption(
                      enableTracking: false,
                      unFollowUser: false,
                    ),
                    zoomOption: const ZoomOption(
                      initZoom: 15,
                      minZoomLevel: 3,
                      maxZoomLevel: 19,
                    ),
                  ),
                  controller: controller.mapController,
                  onGeoPointClicked: (GeoPoint point) async {
                    await controller.onMapTapped(point);
                  },
                  onMapIsReady: (isReady) async {
                    if (isReady) {
                      await controller.onMapReady();
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                style: AppTextStyle.normal,
                controller: controller.officeNameController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Nama Lokasi",
                  prefixIcon: Icon(Icons.location_on),
                  enabled: false,
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                style: AppTextStyle.normal,
                controller: controller.addressController,
                readOnly: true,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "Alamat",
                  prefixIcon: Icon(Icons.home),
                  enabled: false,
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                style: AppTextStyle.normal,
                controller: controller.latitudeController,
                readOnly: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: "Latitude",
                  prefixIcon: Icon(Icons.roundabout_right),
                  enabled: false,
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                style: AppTextStyle.normal,
                controller: controller.longitudeController,
                readOnly: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: "Longitude",
                  prefixIcon: Icon(Icons.roundabout_left),
                  enabled: false,
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                style: AppTextStyle.normal,
                controller: controller.radiusController,
                readOnly: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: "Radius (meter)",
                  prefixIcon: Icon(Icons.rule),
                  enabled: false,
                ),
              ),
              const SizedBox(height: 25),

              Obx(() {
                final office = controller.office.value;
                if (office != null) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.greyprimary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Informasi Lokasi", style: AppTextStyle.heading2),
                        const SizedBox(height: 8),
                        Text(
                          "ID: ${office.id}",
                          style: AppTextStyle.normal.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          "Koordinat: ${office.latitude.toStringAsFixed(6)}, ${office.longitude.toStringAsFixed(6)}",
                          style: AppTextStyle.normal.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
