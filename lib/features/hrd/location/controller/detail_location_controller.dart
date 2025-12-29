import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:presentech/features/hrd/location/model/office.dart';

class DetailLocationController extends GetxController {
  late final Rx<Office?> office = Rx<Office?>(null);

  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController officeNameController = TextEditingController();
  final TextEditingController radiusController = TextEditingController();

  late final MapController mapController;

  final Rxn<GeoPoint> currentMarkerPoint = Rxn<GeoPoint>();
  final isMapReady = false.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args != null && args is Office) {
      office.value = args;
      _populateFields();
    }

    final initialPosition = office.value != null
        ? GeoPoint(
            latitude: office.value!.latitude,
            longitude: office.value!.longitude,
          )
        : GeoPoint(latitude: -7.554417790224685, longitude: 112.23951655089304);

    mapController = MapController(initPosition: initialPosition);
  }

  void _populateFields() {
    if (office.value == null) return;

    officeNameController.text = office.value!.name;
    addressController.text = office.value!.address;
    latitudeController.text = office.value!.latitude.toString();
    longitudeController.text = office.value!.longitude.toString();
    radiusController.text = office.value!.radius.toString();
  }

  Future<void> onMapReady() async {
    if (office.value != null) {
      await mapController.setZoom(zoomLevel: 15);

      final markerPoint = GeoPoint(
        latitude: office.value!.latitude,
        longitude: office.value!.longitude,
      );

      await mapController.addMarker(
        markerPoint,
        markerIcon: const MarkerIcon(
          icon: Icon(Icons.location_pin, color: Colors.red, size: 48),
        ),
      );

      currentMarkerPoint.value = markerPoint;
    }

    isMapReady.value = true;
  }

  Future<void> onMapTapped(GeoPoint point) async {
    if (currentMarkerPoint.value != null) {
      await mapController.removeMarker(currentMarkerPoint.value!);
    }

    await mapController.addMarker(
      point,
      markerIcon: const MarkerIcon(
        icon: Icon(Icons.location_pin, color: Colors.blue, size: 48),
      ),
    );

    currentMarkerPoint.value = point;
    latitudeController.text = point.latitude.toString();
    longitudeController.text = point.longitude.toString();
  }
}
