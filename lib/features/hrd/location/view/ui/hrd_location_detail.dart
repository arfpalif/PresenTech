import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:presentech/features/hrd/location/controller/detail_location_controller.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/shared/view/components/buttons/gradient_btn.dart';
import 'package:presentech/shared/view/components/textFields/text_field_normal.dart';

class HrdLocationDetail extends GetView<DetailLocationController> {
  const HrdLocationDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          "Detail Lokasi",
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
            ),
            const SizedBox(height: 24),

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
                    decoration: _inputDecoration(
                      label: "Nama Lokasi",
                      icon: Icons.location_on,
                    ),
                    readOnly: false,
                  ),
                  const SizedBox(height: 16),

                  TextFieldNormal(
                    style: AppTextStyle.normal,
                    controller: controller.addressController,
                    maxLines: 2,
                    decoration: _inputDecoration(
                      label: "Alamat",
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
                          decoration: _inputDecoration(
                            label: "Latitude",
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
                          decoration: _inputDecoration(
                            label: "Longitude",
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
                    decoration: _inputDecoration(
                      label: "Radius (meter)",
                      icon: Icons.radar,
                    ),
                  ),
                  const SizedBox(height: 30),

                  AppGradientButton(
                    text: "Update Location",
                    onPressed: () {
                      controller.updateOfficeLocation(
                        address: controller.addressController.text,
                        latitude:
                            double.tryParse(
                              controller.latitudeController.text,
                            ) ??
                            0.0,
                        longitude:
                            double.tryParse(
                              controller.longitudeController.text,
                            ) ??
                            0.0,
                        name: controller.officeNameController.text,
                        officeId: controller.office.value!.id.toInt(),
                        radius:
                            double.tryParse(controller.radiusController.text) ??
                            0,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Info Card
            Obx(() {
              final office = controller.office.value;
              if (office != null) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white, // Changed to white for consistency
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: ColorStyle.colorPrimary,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Current Data",
                            style: AppTextStyle.heading2.copyWith(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow("ID", "${office.id}"),
                      _buildInfoRow(
                        "Coordinate",
                        "${office.latitude.toStringAsFixed(6)}, ${office.longitude.toStringAsFixed(6)}",
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
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyle.normal.copyWith(color: Colors.grey[600]),
          ),
          Text(
            value,
            style: AppTextStyle.normal.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey),
      filled: true,
      fillColor: Colors.grey[50], // Consistent text field background
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: ColorStyle.colorPrimary),
      ),
    );
  }
}
