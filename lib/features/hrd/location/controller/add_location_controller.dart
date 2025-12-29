import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:presentech/features/hrd/location/model/office.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddLocationController extends GetxController {
  final TextEditingController officeNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController radiusController = TextEditingController(
    text: '50',
  );

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
      initPosition: GeoPoint(
        latitude: -7.554417790224685,
        longitude: 112.23951655089304,
      ),
    );
  }

  Future<void> onMapReady() async {
    await mapController.setZoom(zoomLevel: 15);
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

      final response = await supabase
          .from('offices')
          .select('*')
          .order('id', ascending: true);

      final data = (response as List).map((e) {
        debugPrint("PARSING OFFICE: $e");
        return Office.fromJson(e);
      }).toList();

      offices.assignAll(data);
    } catch (e) {
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
    final address = this.addressController.text.trim();
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
      await supabase.from('offices').insert({
        'name': name,
        'address': address,
        'latitude': lat,
        'longitude': lng,
        'radius': radius,
      });
      await fetchOffices();

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
