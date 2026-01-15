import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/features/employee/location/controller/location_controller.dart';
import 'package:presentech/shared/styles/color_style.dart';

class EmployeeLocationPage extends GetView<LocationController> {
  const EmployeeLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          "Detail Lokasi Kantor",
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final office = controller.office.value;
        if (office == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_off_rounded, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  "Data lokasi tidak ditemukan",
                  style: AppTextStyle.heading2.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
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
                      offset: const Offset(0, 5),
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
              const SizedBox(height: 24),

              // Details Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.business_rounded, color: ColorStyle.colorPrimary),
                        const SizedBox(width: 8),
                        Text(
                          "Informasi Kantor",
                          style: AppTextStyle.heading2.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildDetailItem("Nama Lokasi", office.name, Icons.location_on),
                    const Divider(height: 32),
                    _buildDetailItem("Alamat", office.address, Icons.home),
                    const Divider(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailItem(
                            "Latitude",
                            office.latitude.toString(),
                            Icons.roundabout_right,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDetailItem(
                            "Longitude",
                            office.longitude.toString(),
                            Icons.roundabout_left,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    _buildDetailItem(
                      "Radius Absensi",
                      "${office.radius} meter",
                      Icons.radar,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Hint Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ColorStyle.colorPrimary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ColorStyle.colorPrimary.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: ColorStyle.colorPrimary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Pastikan Anda berada dalam radius yang ditentukan untuk melakukan absensi.",
                        style: AppTextStyle.smallText.copyWith(color: ColorStyle.colorPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyle.smallText.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyle.normal.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
