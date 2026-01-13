import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:presentech/features/hrd/location/controller/add_location_controller.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/shared/view/components/buttons/gradient_btn.dart';
import 'package:presentech/shared/view/components/textFields/text_field_normal.dart';
import 'package:presentech/shared/styles/input_style.dart';

class HrdAddLocation extends GetView<AddLocationController> {
  const HrdAddLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          "Tambah Lokasi",
          style: AppTextStyle.heading1.copyWith(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
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
              colors: <Color>[ColorStyle.colorPrimary, ColorStyle.greenPrimary],
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map Container
            Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
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
                  onMapIsReady: (isReady) async {
                    if (isReady) {
                      await controller.onMapReady();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                "Long press on map to pin location",
                style: AppTextStyle.normal.copyWith(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Details Form Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Location Details",
                    style: AppTextStyle.heading2.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextFieldNormal(
                    controller: controller.officeNameController,
                    decoration: AppInputStyle.decoration(
                      labelText: "Nama Lokasi",
                      icon: Icons.location_on,
                    ),
                    readOnly: false,
                  ),
                  const SizedBox(height: 16),

                  TextFieldNormal(
                    style: AppTextStyle.normal,
                    controller: controller.addressController,
                    maxLines: 2,
                    decoration: AppInputStyle.decoration(
                      labelText: "Alamat",
                      icon: Icons.home,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: TextFieldNormal(
                          controller: controller.latitudeController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: AppInputStyle.decoration(
                            labelText: "Latitude",
                            icon: Icons.roundabout_right,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: TextFieldNormal(
                          controller: controller.longitudeController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: AppInputStyle.decoration(
                            labelText: "Longitude",
                            icon: Icons.roundabout_left,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  TextFieldNormal(
                    style: AppTextStyle.normal,
                    controller: controller.radiusController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: AppInputStyle.decoration(
                      labelText: "Radius (meter)",
                      icon: Icons.radar,
                    ),
                  ),
                  const SizedBox(height: 30),

                  Obx(
                    () => controller.isSaving.value
                        ? const Center(child: CircularProgressIndicator())
                        : AppGradientButton(
                            text: "Add Location",
                            onPressed: () {
                              controller.submitLocation();
                            },
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
