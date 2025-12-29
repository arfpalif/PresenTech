import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:presentech/features/hrd/location/controller/add_location_controller.dart';
import 'package:presentech/features/hrd/location/controller/detail_location_controller.dart';
import 'package:presentech/shared/view/components/Gradient_btn.dart';
import 'package:presentech/shared/view/themes/themes.dart';

class HrdAddLocation extends GetView<AddLocationController> {
  const HrdAddLocation({super.key});

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

                decoration: const InputDecoration(
                  labelText: "Nama Lokasi",
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                style: AppTextStyle.normal,
                controller: controller.addressController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "Alamat",
                  prefixIcon: Icon(Icons.home),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                style: AppTextStyle.normal,
                controller: controller.latitudeController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: "Latitude",
                  prefixIcon: Icon(Icons.roundabout_right),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                style: AppTextStyle.normal,
                controller: controller.longitudeController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: "Longitude",
                  prefixIcon: Icon(Icons.roundabout_left),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                style: AppTextStyle.normal,
                controller: controller.radiusController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: "Radius (meter)",
                  prefixIcon: Icon(Icons.rule),
                ),
              ),
              const SizedBox(height: 25),

              AppGradientButton(
                text: "Tambah lokasi",
                onPressed: controller.submitLocation,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
