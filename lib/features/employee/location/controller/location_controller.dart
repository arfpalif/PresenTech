import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/location/repositories/employee_location_repository.dart';
import 'package:presentech/shared/view/components/snackbar/failed_snackbar.dart';
import 'package:presentech/features/hrd/location/model/office.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LocationController extends GetxController {
  //repository
  final locationRepo = EmployeeLocationRepository();
  final isLoading = false.obs;
  final Rx<Office?> office = Rx<Office?>(null);

  final supabase = Supabase.instance.client;

  //map controller
  late MapController mapController;
  final isMapReady = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Temporary initial position, will be updated once office is fetched
    mapController = MapController(
      initPosition: GeoPoint(latitude: -7.5544, longitude: 112.2395),
    );
    fetchUserOffice();
  }

  Future<void> fetchUserOffice() async {
    try {
      isLoading.value = true;
      final userId = supabase.auth.currentUser?.id ?? "";

      final response = await locationRepo.fetchUserOffice(userId);

      if (response != null) {
        office.value = response;

        if (office.value != null && isMapReady.value) {
          await mapController.moveTo(
            GeoPoint(
              latitude: office.value!.latitude,
              longitude: office.value!.longitude,
            ),
          );

          await mapController.addMarker(
            GeoPoint(
              latitude: office.value!.latitude,
              longitude: office.value!.longitude,
            ),
            markerIcon: const MarkerIcon(
              icon: Icon(Icons.location_pin, color: Colors.red, size: 48),
            ),
          );
        }
      }
    } catch (e) {
      FailedSnackbar.show("Tidak dapat memuat data lokasi: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onMapReady() async {
    isMapReady.value = true;
    if (office.value != null) {
      await mapController.setZoom(zoomLevel: 15);

      final point = GeoPoint(
        latitude: office.value!.latitude,
        longitude: office.value!.longitude,
      );

      await mapController.moveTo(point);
      await mapController.addMarker(
        point,
        markerIcon: const MarkerIcon(
          icon: Icon(Icons.location_pin, color: Colors.red, size: 48),
        ),
      );
    }
  }

  /// Refresh office list
  Future<void> refreshOffice() async {
    await fetchUserOffice();
  }
}
