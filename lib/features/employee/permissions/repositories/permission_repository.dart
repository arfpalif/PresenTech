import 'package:get/get.dart';
import 'package:presentech/constants/api_constant.dart';
import 'package:presentech/shared/models/permission.dart';
import 'package:presentech/utils/services/connectivity_service.dart';
import 'package:presentech/utils/services/database_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PermissionRepository {
  final SupabaseClient supabase = Supabase.instance.client;
  final ConnectivityService connectivityService =
      Get.find<ConnectivityService>();
  final DatabaseService databaseService = Get.find<DatabaseService>();

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
          await databaseService.syncPermissionToLocal(
            remotePermissions,
            userId,
          );
        }
      }
    } catch (e) {
      print("Gagal fetch Supabase (Permissions): $e");
    }

    try {
      return await databaseService.getPermissionsLocally(userId);
    } catch (e) {
      print("Gagal fetch local (Permissions): $e");
      return remotePermissions;
    }
  }

  Future<void> syncOfflinePermissions() async {
    try {
      final unsyncedPermissions = await databaseService
          .getUnsyncedPermissions();
      if (unsyncedPermissions.isEmpty) return;

      for (var permission in unsyncedPermissions) {
        try {
          if (permission.id != null)
            if (permission.syncAction == 'insert') {
              await syncInsertToSupabase(permission.toJson());
            } else if (permission.syncAction == 'update' &&
                permission.id != null) {
              final data = permission.toJson();
              data.remove('id');
              await syncUpdateToSupabase(permission.id!, data);
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
    final localId = await databaseService.addPermissionToSyncQueue(
      data,
      'insert',
    );
    print("Permission disimpan di HP (Mode Instan). ID: $localId");

    if (connectivityService.isOnline.value) {
      syncInsertToSupabase({...data, 'id': localId});
    }
    return localId;
  }

  Future<void> updatePermission(int id, Map<String, dynamic> data) async {
    try {
      final db = await databaseService.database;
      await db.update(
        ApiConstant.tablePermissions,
        {...data, 'is_synced': 0, 'sync_action': 'update'},
        where: 'id = ?',
        whereArgs: [id],
      );

      if (connectivityService.isOnline.value) {
        syncUpdateToSupabase(id, data);
      }
    } catch (e) {
      print("Gagal update local (Permission): $e");
    }
  }

  Future<void> syncInsertToSupabase(Map<String, dynamic> data) async {
    final localId = data['id'];

    try {
      final Map<String, dynamic> supabaseData = Map.from(data);
      supabaseData.remove('id');
      supabaseData.remove('is_synced');
      supabaseData.remove('sync_action');

      final createdAt = data['created_at'];

      final response = await supabase
          .from(ApiConstant.tablePermissions)
          .insert(supabaseData)
          .select()
          .single();

      final remoteId = response['id'];
      print("Background Permission Sync: Success! Remote ID: $remoteId");

      final db = await databaseService.database;

      await db.transaction((txn) async {
        final existing = await txn.query(
          ApiConstant.tablePermissions,
          where: 'id = ?',
          whereArgs: [remoteId],
        );

        if (existing.isNotEmpty) {
          if (localId != null) {
            await txn.delete(
              ApiConstant.tablePermissions,
              where: 'id = ?',
              whereArgs: [localId],
            );
            print(
              "Background: Found duplicate remote ID $remoteId, removed local ID $localId",
            );
          } else {
            await txn.delete(
              ApiConstant.tablePermissions,
              where: 'created_at = ? AND user_id = ?',
              whereArgs: [createdAt, data['user_id']],
            );
          }
        } else {
          if (localId != null) {
            await txn.update(
              ApiConstant.tablePermissions,
              {'id': remoteId, 'is_synced': 1, 'sync_action': null},
              where: 'id = ?',
              whereArgs: [localId],
            );
          } else {
            await txn.update(
              ApiConstant.tablePermissions,
              {'id': remoteId, 'is_synced': 1, 'sync_action': null},
              where: 'created_at = ? AND user_id = ?',
              whereArgs: [createdAt, data['user_id']],
            );
          }
        }
      });
    } catch (e) {
      print("Background Permission Sync Failed: $e");
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

      final db = await databaseService.database;
      await db.update(
        ApiConstant.tablePermissions,
        {'is_synced': 1, 'sync_action': null},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Background Permission Update Failed: $e");
    }
  }

  Future<void> syncDeleteToSupabase(int id) async {
    try {
      await supabase.from(ApiConstant.tablePermissions).delete().eq('id', id);
      await databaseService.deletePermissionLocally(id);
    } catch (e) {
      print("Background Permission Delete Failed: $e");
    }
  }
}
