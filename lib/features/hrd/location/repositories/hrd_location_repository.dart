import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:presentech/constants/api_constant.dart';
import 'package:presentech/features/hrd/location/model/office.dart';
import 'package:presentech/utils/database/dao/location_dao.dart';
import 'package:presentech/utils/database/database.dart';
import 'package:presentech/utils/services/connectivity_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drift/drift.dart' as drift;

class HrdLocationRepository {
  final supabase = Supabase.instance.client;
  final connectivityService = Get.find<ConnectivityService>();
  final locationDao = Get.find<LocationDao>();

  final RxList<Office> offices = <Office>[].obs;
  final isLoading = false.obs;

  Future<void> syncPendingLocations() async {
    if (!connectivityService.isOnline.value) return;

    try {
      final unsynced = await locationDao.getUnsyncedLocations();
      for (var row in unsynced) {
        if (row.syncAction == 'INSERT') {
          final res = await supabase
              .from(ApiConstant.tableOffices)
              .insert({
                'name': row.name,
                'address': row.address,
                'latitude': row.latitude,
                'longitude': row.longitude,
                'radius': row.radius,
              })
              .select()
              .single();

          await locationDao.markAsSynced(row.id, res['id']);
        } else if (row.syncAction == 'UPDATE') {
          await supabase
              .from(ApiConstant.tableOffices)
              .update({
                'name': row.name,
                'address': row.address,
                'latitude': row.latitude,
                'longitude': row.longitude,
                'radius': row.radius,
              })
              .eq('id', row.id);

          await locationDao.markAsSynced(row.id, row.id);
        }
      }
    } catch (e) {
      debugPrint('Error syncing pending locations: $e');
    }
  }

  Future<List<Office>> fetchOffices() async {
    try {
      if (connectivityService.isOnline.value) {
        final response = await supabase
            .from(ApiConstant.tableOffices)
            .select('*')
            .order('id', ascending: true);

        final remoteData = (response as List)
            .map((e) => Office.fromJson(e))
            .toList();

        await locationDao.syncOfficesToLocal(
          remoteData.map((e) => e.toDrift()).toList(),
        );
        return remoteData;
      } else {
        final localData = await locationDao.db
            .select(locationDao.locationsTable)
            .get();
        return localData.map((e) => Office.fromDrift(e)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching offices: $e');
      final localData = await locationDao.db
          .select(locationDao.locationsTable)
          .get();
      return localData.map((e) => Office.fromDrift(e)).toList();
    }
  }

  Future<void> addOfficeLocation({
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required double radius,
  }) async {
    try {
      isLoading.value = true;

      final companion = LocationsTableCompanion(
        name: drift.Value(name),
        address: drift.Value(address),
        latitude: drift.Value(latitude),
        longitude: drift.Value(longitude),
        radius: drift.Value(radius),
        isSynced: const drift.Value(false),
        syncAction: const drift.Value('INSERT'),
      );

      final tempId = await locationDao.insertLocation(companion);

      if (connectivityService.isOnline.value) {
        final res = await supabase
            .from(ApiConstant.tableOffices)
            .insert({
              'name': name,
              'address': address,
              'latitude': latitude,
              'longitude': longitude,
              'radius': radius,
            })
            .select()
            .single();

        await locationDao.markAsSynced(tempId, res['id']);
      }
    } catch (e) {
      debugPrint('Error adding office location: $e');
      // Keep local data as unsynced
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateOfficeLocation(
    Office office, {
    String? officeId,
    double? latitude,
    double? longitude,
    double? radius,
    String? name,
    String? address,
  }) async {
    try {
      isLoading.value = true;
      final id = int.parse(officeId!);

      // Update locally first
      final companion = LocationsTableCompanion(
        name: drift.Value(name ?? office.name),
        address: drift.Value(address ?? office.address),
        latitude: drift.Value(latitude ?? office.latitude),
        longitude: drift.Value(longitude ?? office.longitude),
        radius: drift.Value(radius ?? office.radius),
        isSynced: const drift.Value(false),
        syncAction: const drift.Value('UPDATE'),
      );

      await locationDao.updateLocation(id, companion);

      // Try sync if online
      if (connectivityService.isOnline.value) {
        await supabase
            .from(ApiConstant.tableOffices)
            .update({
              'latitude': latitude ?? office.latitude,
              'longitude': longitude ?? office.longitude,
              'radius': radius ?? office.radius,
              'name': name ?? office.name,
              'address': address ?? office.address,
            })
            .eq('id', id);

        await locationDao.markAsSynced(id, id);
      }
    } catch (e) {
      debugPrint('Error updating office location: $e');
      // Keep local data as unsynced
    } finally {
      isLoading.value = false;
    }
  }
}
