import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/homepage/controller/navigation_controller.dart';
import 'package:presentech/features/hrd/location/controller/location_controller.dart';
import 'package:presentech/features/views/components/Gradient_btn.dart';
import 'package:presentech/features/views/themes/themes.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 300,
                child: GestureDetector(
                  onLongPress: () async {
                    final center = await controller.mapController.centerMap;
                    if (center != null) {
                      await controller.setMarker(center);
                    }
                  },
                  child: OSMFlutter(
                    controller: controller.mapController,
                    onGeoPointClicked: (GeoPoint point) async {
                      await controller.setMarker(point);
                    },
                    onMapIsReady: (isReady) async {
                      if (isReady) {
                        await controller.mapController.setZoom(zoomLevel: 15);
                      }
                    },
                    osmOption: OSMOption(
                      userTrackingOption: const UserTrackingOption(
                        enableTracking: false,
                        unFollowUser: false,
                      ),
                      zoomOption: const ZoomOption(
                        initZoom: 8,
                        minZoomLevel: 3,
                        maxZoomLevel: 19,
                      ),
                      userLocationMarker: UserLocationMaker(
                        personMarker: const MarkerIcon(
                          icon: Icon(
                            Icons.location_history_rounded,
                            color: Colors.red,
                            size: 48,
                          ),
                        ),
                        directionArrowMarker: const MarkerIcon(
                          icon: Icon(Icons.double_arrow, size: 48),
                        ),
                      ),
                      roadConfiguration: const RoadOption(
                        roadColor: Colors.yellowAccent,
                      ),
                      showZoomController: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                style: AppTextStyle.normal,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                controller: controller.latitudeController,
                decoration: InputDecoration(
                  labelText: "Latitude",
                  hintStyle: AppTextStyle.normal,
                  prefixIcon: const Icon(Icons.roundabout_right),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                style: AppTextStyle.normal,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                controller: controller.longitudeController,
                decoration: InputDecoration(
                  labelText: "Longitude",
                  hintStyle: AppTextStyle.normal,
                  prefixIcon: const Icon(Icons.roundabout_left),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                style: AppTextStyle.normal,
                keyboardType: TextInputType.text,
                controller: controller.addressController,
                decoration: InputDecoration(
                  labelText: "Address",
                  hintStyle: AppTextStyle.normal,
                  prefixIcon: const Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                style: AppTextStyle.normal,
                keyboardType: TextInputType.text,
                controller: controller.officeNameController,
                decoration: InputDecoration(
                  labelText: "Office name",
                  hintStyle: AppTextStyle.normal,
                  prefixIcon: const Icon(Icons.local_post_office),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                style: AppTextStyle.normal,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                controller: controller.radiusController,
                decoration: InputDecoration(
                  labelText: "Absence radius",
                  hintStyle: AppTextStyle.normal,
                  prefixIcon: const Icon(Icons.rule),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                final saving = controller.isSaving.value;
                return AppGradientButton(
                  text: saving ? "Saving..." : "Submit",
                  onPressed: saving
                      ? () {}
                      : () async {
                          final success = await controller.submitLocation();
                          if (success) {
                            Get.find<NavigationController>().changePage(0);
                          }
                        },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
