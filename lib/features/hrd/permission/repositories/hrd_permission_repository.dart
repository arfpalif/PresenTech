import 'package:get/get.dart' show Get, Inst;
import 'package:presentech/constants/api_constant.dart';
import 'package:presentech/shared/models/permission.dart';
import 'package:presentech/shared/view/components/snackbar/failed_snackbar.dart';
import 'package:presentech/utils/database/dao/permission_dao.dart';
import 'package:presentech/utils/enum/permission_status.dart';
import 'package:presentech/utils/services/connectivity_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HrdPermissionRepository {
  final supabase = Supabase.instance.client;
  final ConnectivityService connectivityService =
      Get.find<ConnectivityService>();
  final PermissionDao _permissionDao = Get.find<PermissionDao>();

  Future<List<Permission>> fetchPermissions() async {
    List<Permission> remotePermissions = [];

    try {
      if (connectivityService.isOnline.value) {
        await syncOfflinePermissions();
      }
      if (connectivityService.isOnline.value) {
        final response = await supabase
            .from('permissions')
            .select()
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
      FailedSnackbar.show('Failed to fetch permissions from server');
      throw Exception("Failed to fetch permissions: $e");
    }
    return remotePermissions;
  }

  Future<List<Map<String, dynamic>>> fetchPermissionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final response = await supabase
        .from(ApiConstant.tablePermissions)
        .select()
        .gte('created_at', startDate.toIso8601String())
        .lte('created_at', endDate.toIso8601String())
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> fetchPermissionsByStatus(
    String status,
  ) async {
    final response = await supabase
        .from('permissions')
        .select()
        .eq('status', status)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> approvePermission(int permissionId, String? feedback) async {
    final local = await _permissionDao.getPermissionById(permissionId);
    if (local != null) {
      final updated = Permission.fromDrift(local);
      updated.status = PermissionStatus.approved;
      updated.feedback = feedback;
      updated.isSynced = 0;
      if (updated.syncAction != 'insert') {
        updated.syncAction = 'update';
      }
      await _permissionDao.updatePermissionData(permissionId, updated.toDrift());
    }

    if (connectivityService.isOnline.value) {
      await syncUpdateToSupabase(permissionId, {
        'status': 'approved',
        'feedback': feedback,
      });
    }
  }

  Future<void> rejectPermission(int permissionId, String feedback) async {
    final local = await _permissionDao.getPermissionById(permissionId);
    if (local != null) {
      final updated = Permission.fromDrift(local);
      updated.status = PermissionStatus.rejected;
      updated.feedback = feedback;
      updated.isSynced = 0;
      if (updated.syncAction != 'insert') {
        updated.syncAction = 'update';
      }
      await _permissionDao.updatePermissionData(permissionId, updated.toDrift());
    }

    if (connectivityService.isOnline.value) {
      await syncUpdateToSupabase(permissionId, {
        'status': 'rejected',
        'feedback': feedback,
      });
    }
  }

  Future<void> syncOfflinePermissions() async {
    try {
      final unsyncedData = await _permissionDao.getUnsyncedPermissions();
      final unsyncedPermissions =
          unsyncedData.map((e) => Permission.fromDrift(e)).toList();

      if (unsyncedPermissions.isEmpty) return;

      for (var permission in unsyncedPermissions) {
        try {
          if (permission.id != null) {
            if (permission.syncAction == 'update') {
              final data = permission.toJson();
              data.remove('id');
              await syncUpdateToSupabase(permission.id!, data);
            }
          }
        } catch (e) {
          FailedSnackbar.show('Failed to sync permission ${permission.id}');
        }
      }
    } catch (e) {
      FailedSnackbar.show('Failed to sync offline permissions');
    }
  }

  Future<void> syncUpdateToSupabase(int id, Map<String, dynamic> data) async {
    try {
      final Map<String, dynamic> supabaseData = Map.from(data)
        ..remove('id')
        ..remove('is_synced')
        ..remove('sync_action');

      await supabase.from('permissions').update(supabaseData).eq('id', id);

      await _permissionDao.updatePermissionSyncStatus(id, 1, null);
    } catch (e) {
      FailedSnackbar.show('Failed to update permission on server');
    }
  }
}
