import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LocationController extends GetxController {
  // Text controllers managed here so GetView can stay stateless
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController officeNameController = TextEditingController();
  final TextEditingController radiusController = TextEditingController();

  final MapController mapController = MapController(
    initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
  );

  final Rxn<GeoPoint> currentMarkerPoint = Rxn<GeoPoint>();
  final isSaving = false.obs;

  final supabase = Supabase.instance.client;

  Future<bool> saveLocation({
    required double latitude,
    required double longitude,
    required String address,
    required String name,
    required double radius,
  }) async {
    try {
      final res = await supabase.from('offices').insert({
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'name': name,
        'radius': radius,
      });

      print("INSERT SUCCESS: $res");
      return true;
    } catch (e) {
      print("INSERT ERROR: $e");
      return false;
    }
  }

  Future<void> setMarker(GeoPoint point) async {
    if (currentMarkerPoint.value != null) {
      await mapController.removeMarker(currentMarkerPoint.value!);
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

    currentMarkerPoint.value = point;
    latitudeController.text = point.latitude.toString();
    longitudeController.text = point.longitude.toString();
  }

  Future<bool> submitLocation() async {
    final lat = double.tryParse(latitudeController.text);
    final lng = double.tryParse(longitudeController.text);
    final radius = double.tryParse(radiusController.text);

    if (lat == null || lng == null || radius == null) {
      Get.snackbar("Error", "Semua field harus terisi");
      return false;
    }

    if (addressController.text.isEmpty || officeNameController.text.isEmpty) {
      Get.snackbar("Error", "Semua field harus terisi");
      return false;
    }

    isSaving.value = true;
    try {
      final success = await saveLocation(
        latitude: lat,
        longitude: lng,
        address: addressController.text,
        name: officeNameController.text,
        radius: radius,
      );

      if (success) {
        Get.snackbar("Berhasil", "Lokasi tersimpan");
      } else {
        Get.snackbar("Error", "Gagal menyimpan lokasi");
      }
      return success;
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    latitudeController.dispose();
    longitudeController.dispose();
    addressController.dispose();
    officeNameController.dispose();
    radiusController.dispose();
    mapController.dispose();
    super.onClose();
  }
}
