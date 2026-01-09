import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:presentech/features/hrd/location/controller/location_controller.dart';
import 'package:presentech/features/hrd/location/model/office.dart';
import 'package:presentech/features/hrd/location/repositories/hrd_location_repository.dart';

class DetailLocationController extends GetxController {
  //repository
  final hrdLocationRepo = HrdLocationRepository();
  late final Rx<Office?> office = Rx<Office?>(null);
  RxList<Office> offices = <Office>[].obs;
  final locationC = Get.find<LocationController>();
  //controllers
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController officeNameController = TextEditingController();
  final TextEditingController radiusController = TextEditingController();

  //variables
  final isLoading = false.obs;
  final isMapReady = false.obs;

  //map controller
  late final MapController mapController;

  //model
  final Rxn<GeoPoint> currentMarkerPoint = Rxn<GeoPoint>();

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

  Future<void> fetchOffices() async {
    try {
      isLoading.value = true;

      final response = await hrdLocationRepo.fetchOffices();

      final data = (response as List).map((e) {
        return Office.fromJson(e);
      }).toList();

      offices.assignAll(data);
    } catch (e) {
      print("Error: $e");
      Get.snackbar(
        "Error Mengambil Lokasi",
        "Tidak dapat memuat data lokasi: ${e.toString()}",
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateOfficeLocation({
    required int officeId,
    required double latitude,
    required double longitude,
    required String name,
    required String address,
    required double radius,
  }) async {
    try {
      isLoading.value = true;

      await hrdLocationRepo.updateOfficeLocation(
        office.value!,
        officeId: officeId.toString(),
        latitude: latitude,
        longitude: longitude,
        name: name,
        address: address,
        radius: radius,
      );
      Get.back();
      await locationC.fetchOffices();

      Get.snackbar('Berhasil', 'Lokasi kantor berhasil diperbarui');
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui lokasi: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteOfficeLocation(String officeId) async {
    try {
      isLoading.value = true;

      await hrdLocationRepo.deleteOfficeLocation(officeId);
      await fetchOffices();

      Get.back();
      Get.snackbar('Berhasil', 'Lokasi kantor berhasil dihapus');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus lokasi: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
