import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:presentech/features/employee/homepage/controller/navigation_controller.dart';
import 'package:presentech/features/hrd/location/controller/location_controller.dart';
import 'package:presentech/features/views/components/Gradient_btn.dart';
import 'package:presentech/features/views/themes/themes.dart';

class HrdLocation extends StatefulWidget {
  const HrdLocation({super.key});

  @override
  State<HrdLocation> createState() => _HrdLocationState();
}

class _HrdLocationState extends State<HrdLocation> {
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController officeNameController = TextEditingController();
  final TextEditingController radiusController = TextEditingController();

  final locationC = Get.put(LocationController());

  String? selectedLevel;
  String? selectedPriority;
  MapController mapController = MapController(
    initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
  );
  GeoPoint? currentMarkerPoint;

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
                    GeoPoint? center = await mapController.centerMap;
                    if (currentMarkerPoint != null) {
                      await mapController.removeMarker(currentMarkerPoint!);
                    }
                    await mapController.addMarker(
                      center,
                      markerIcon: const MarkerIcon(
                        icon: Icon(
                          Icons.location_pin,
                          color: Colors.blue,
                          size: 48,
                        ),
                      ),
                    );
                    currentMarkerPoint = center;
                    setState(() {
                      latitudeController.text = center.latitude.toString();
                      longitudeController.text = center.longitude.toString();
                    });
                  },
                  child: OSMFlutter(
                    controller: mapController,
                    onGeoPointClicked: (GeoPoint point) async {
                      if (currentMarkerPoint != null) {
                        await mapController.removeMarker(currentMarkerPoint!);
                      }
                      await mapController.addMarker(
                        point,
                        markerIcon: const MarkerIcon(
                          icon: Icon(
                            Icons.location_pin,
                            color: Colors.blue,
                            size: 48,
                          ),
                        ),
                      );
                      currentMarkerPoint = point;
                      setState(() {
                        latitudeController.text = point.latitude.toString();
                        longitudeController.text = point.longitude.toString();
                      });
                    },
                    onMapIsReady: (isReady) async {
                      if (isReady) {
                        await mapController.setZoom(zoomLevel: 15);
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
                      showZoomController: true, // Add zoom in/out buttons
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                style: AppTextStyle.normal,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: latitudeController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "Latitude",
                  hintStyle: AppTextStyle.normal,
                  prefixIcon: Icon(Icons.roundabout_right),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                style: AppTextStyle.normal,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: longitudeController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "Longitude",
                  hintStyle: AppTextStyle.normal,
                  prefixIcon: Icon(Icons.roundabout_left),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                style: AppTextStyle.normal,
                keyboardType: TextInputType.text,
                controller: addressController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "Address",
                  hintStyle: AppTextStyle.normal,
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                style: AppTextStyle.normal,
                keyboardType: TextInputType.text,
                controller: officeNameController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "Office name",
                  hintStyle: AppTextStyle.normal,
                  prefixIcon: Icon(Icons.local_post_office),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                style: AppTextStyle.normal,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: radiusController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "Absence radius",
                  hintStyle: AppTextStyle.normal,
                  prefixIcon: Icon(Icons.rule),
                ),
              ),
              SizedBox(height: 20),
              AppGradientButton(
                text: "Submit",
                onPressed: () async {
                  final lat = double.tryParse(latitudeController.text);
                  final lng = double.tryParse(longitudeController.text);
                  final radius = double.tryParse(radiusController.text);

                  if (lat == null || lng == null || radius == null) {
                    Get.snackbar("Eror", "Semua field harus terisi");
                    return;
                  }
                  if (addressController.text.isEmpty ||
                      officeNameController.text.isEmpty) {
                    Get.snackbar("Error", "Semua field harus terisi");
                    return;
                  }
                  var success = await locationC.saveLocation(
                    latitude: lat,
                    longitude: lng,
                    address: addressController.text,
                    name: officeNameController.text,
                    radius: radius,
                  );

                  if (success) {
                    Get.snackbar("Berhasil", "Hore");
                    NavigationController().changePage(0);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
