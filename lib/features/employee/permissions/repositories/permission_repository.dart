import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/constants/api_constant.dart';
import 'package:presentech/shared/models/permission.dart';
import 'package:presentech/utils/database/dao/permission_dao.dart';
import 'package:presentech/utils/enum/permission_status.dart';
import 'package:presentech/utils/services/connectivity_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PermissionRepository {
  final SupabaseClient supabase = Supabase.instance.client;
  final ConnectivityService connectivityService =
      Get.find<ConnectivityService>();
  final PermissionDao _permissionDao = Get.find<PermissionDao>();

  Future<List<Permission>> getPermissions(String userId) async {
    List<Permission> remotePermissions = [];

    if (connectivityService.isOnline.value) {
      await syncOfflinePermissions();
    }

    try {
      if (connectivityService.isOnline.value) {
        final response = await supabase
            .from('permissions')
            .select()
            .eq('user_id', userId)
            .order('created_at', ascending: false);

        remotePermissions = (response as List)
            .map((e) => Permission.fromJson(e))
            .toList();

        if (remotePermissions.isNotEmpty) {
          await _permissionDao.syncPermissionToLocal(
            remotePermissions.map((e) => e.toDrift()).toList(),
          );
        }
      }
    } catch (e) {
      print("Gagal fetch Supabase (Permissions): $e");
    }

    try {
      final localData = await _permissionDao.getPermissionsByUser(userId);
      return localData.map((e) => Permission.fromDrift(e)).toList();
    } catch (e) {
      print("Gagal fetch local (Permissions): $e");
      return remotePermissions;
    }
  }

  Future<void> syncOfflinePermissions() async {
    try {
      final unsyncedData = await _permissionDao.getUnsyncedPermissions();
      final unsyncedPermissions = unsyncedData
          .map((e) => Permission.fromDrift(e))
          .toList();

      if (unsyncedPermissions.isEmpty) return;

      for (var permission in unsyncedPermissions) {
        try {
          if (permission.id != null) {
            if (permission.syncAction == 'insert') {
              await syncInsertToSupabase(permission.toJson());
            } else if (permission.syncAction == 'update') {
              final data = permission.toJson();
              data.remove('id');
              await syncUpdateToSupabase(permission.id!, data);
            }
          }
        } catch (e) {
          print("Gagal sync permission ${permission.id}: $e");
        }
      }
    } catch (e) {
      print("Error Sync Permissions: $e");
    }
  }

  Future<int?> insertPermission(Map<String, dynamic> data) async {
    final permission = Permission.fromJson(data);
    permission.isSynced = 0;
    permission.syncAction = 'insert';

    final localId = await _permissionDao.insertPermission(permission.toDrift());
    print("Permission disimpan di HP (Mode Instan). ID: $localId");

    if (connectivityService.isOnline.value) {
      syncInsertToSupabase({...data, 'id': localId});
    }
    return localId;
  }

  Future<void> updatePermission(int id, Map<String, dynamic> data) async {
    try {
      final local = await _permissionDao.getPermissionById(id);
      if (local == null) return;

      final updated = Permission.fromDrift(local);

      if (data.containsKey('status')) {
        final statusVal = data['status'];
        updated.status = statusVal is PermissionStatus
            ? statusVal
            : PermissionStatusX.fromString(statusVal.toString());
      }
      if (data.containsKey('feedback')) {
        updated.feedback = data['feedback'];
      }

      if (updated.syncAction != 'insert') {
        updated.syncAction = 'update';
      }
      updated.isSynced = 0;

      await _permissionDao.updatePermissionData(id, updated.toDrift());
      debugPrint(
        "Local Update Success (ID: $id, Action: ${updated.syncAction})",
      );

      if (connectivityService.isOnline.value && local.isSynced == 1) {
        await syncUpdateToSupabase(id, data);
      }
    } catch (e) {
      debugPrint("Update Error: $e");
    }
  }

  Future<void> syncInsertToSupabase(Map<String, dynamic> data) async {
    final localId = data['id'];

    try {
      final Map<String, dynamic> supabaseData = Map.from(data);
      supabaseData.remove('id');
      supabaseData.remove('is_synced');
      supabaseData.remove('sync_action');

      final response = await supabase
          .from(ApiConstant.tablePermissions)
          .insert(supabaseData)
          .select()
          .single();

      final remoteId = response['id'];
      debugPrint("Background Permission Sync: Success! Remote ID: $remoteId");

      await _permissionDao.deletePermissionLocally(localId);
      final permission = Permission.fromJson(data);
      permission.id = remoteId;
      permission.isSynced = 1;
      permission.syncAction = null;
      await _permissionDao.insertPermission(permission.toDrift());

      debugPrint("Background: Local ID $localId updated to $remoteId");
    } catch (e) {
      debugPrint("Background Permission Sync Failed: $e");
    }
  }

  Future<void> syncUpdateToSupabase(int id, Map<String, dynamic> data) async {
    try {
      final Map<String, dynamic> supabaseData = Map.from(data)
        ..remove('id')
        ..remove('is_synced')
        ..remove('sync_action');

      await supabase
          .from(ApiConstant.tablePermissions)
          .update(supabaseData)
          .eq('id', id);

      await _permissionDao.updatePermissionSyncStatus(id, 1, null);
    } catch (e) {
      debugPrint("Background Permission Update Failed: $e");
    }
  }

  Future<void> syncDeleteToSupabase(int id) async {
    try {
      await supabase.from(ApiConstant.tablePermissions).delete().eq('id', id);
      await _permissionDao.deletePermissionLocally(id);
    } catch (e) {
      debugPrint("Background Permission Delete Failed: $e");
    }
  }
}
