import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:presentech/features/hrd/location/controller/location_controller.dart';
import 'package:presentech/features/hrd/location/model/office.dart';
import 'package:presentech/features/hrd/location/repositories/hrd_location_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddLocationController extends GetxController {
  //repository
  final hrdLocationRepo = HrdLocationRepository();

  //others controllers
  final LocationController locationC = Get.find<LocationController>();

  //variables
  final TextEditingController officeNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController radiusController = TextEditingController(
    text: '50',
  );

  //map controller
  late final MapController mapController;

  final Rxn<GeoPoint> currentMarkerPoint = Rxn<GeoPoint>();
  final isMapReady = false.obs;
  final isSaving = false.obs;
  final isLoading = false.obs;
  final RxList<Office> offices = <Office>[].obs;
  final supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    mapController = MapController(
      initPosition: GeoPoint(latitude: 0, longitude: 0),
    );

    // Fallback listener: sometimes the widget callback does not fire, so listen directly
    // to the controller's long-tap notifier to ensure we always handle long presses.
    mapController.listenerMapLongTapping.addListener(() {
      final point = mapController.listenerMapLongTapping.value;
      if (point != null) {
        onLongPressed(point);
      }
    });
  }

  Future<void> onMapReady() async {
    debugPrint('OSM map is ready');
    await mapController.setZoom(zoomLevel: 15);
    isMapReady.value = true;
  }

  Future<void> onLongPressed(GeoPoint point) async {
    if (!isMapReady.value) return;

    debugPrint('Long pressed at: $point');

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

      final data = response.map((e) => Office.fromJson(e)).toList();

      offices.assignAll(data);
    } catch (e) {
      print("Error mengambil lokasi: $e");
      Get.snackbar(
        "Error Mengambil Lokasi",
        "Tidak dapat memuat data lokasi: ${e.toString()}",
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> submitLocation() async {
    final name = officeNameController.text.trim();
    final address = addressController.text.trim();
    final lat = double.tryParse(latitudeController.text.trim());
    final lng = double.tryParse(longitudeController.text.trim());
    final radius = double.tryParse(radiusController.text.trim());

    if (name.isEmpty ||
        address.isEmpty ||
        lat == null ||
        lng == null ||
        radius == null) {
      Get.snackbar('Error', 'Semua field harus terisi dengan benar');
      return false;
    }

    isSaving.value = true;
    try {
      await hrdLocationRepo.addOfficeLocation(
        name: name,
        address: address,
        latitude: lat,
        longitude: lng,
        radius: radius,
      );
      await locationC.fetchOffices();

      Get.back();
      Get.snackbar('Berhasil', 'Lokasi kantor berhasil ditambahkan');
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan lokasi: ${e.toString()}');
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    officeNameController.dispose();
    addressController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    radiusController.dispose();
    mapController.dispose();
    super.onClose();
  }
}
