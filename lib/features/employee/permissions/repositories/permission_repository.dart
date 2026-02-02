import 'package:get/get.dart';
import 'package:presentech/constants/api_constant.dart';
import 'package:presentech/shared/models/permission.dart';
import 'package:presentech/utils/enum/permission_status.dart';
import 'package:presentech/utils/services/connectivity_service.dart';
import 'package:presentech/utils/services/database_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PermissionRepository {
  final SupabaseClient supabase = Supabase.instance.client;
  final ConnectivityService connectivityService =
      Get.find<ConnectivityService>();
  final DatabaseService databaseService = Get.find<DatabaseService>();

  Future<List<Permission>> getPermissions(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
    PermissionStatus? status,
  }) async {
    List<Permission> remotePermissions = [];

    if (connectivityService.isOnline.value) {
      await syncOfflinePermissions();
    }

    try {
      if (connectivityService.isOnline.value) {
        var query = supabase.from('permissions').select().eq('user_id', userId);

        if (startDate != null) {
          query = query.gte('created_at', startDate.toIso8601String());
        }
        if (endDate != null) {
          query = query.lte('created_at', endDate.toIso8601String());
        }
        if (status != null) {
          query = query.eq('status', status.name);
        }

        final response = await query.order('created_at', ascending: false);
        remotePermissions = (response
            .map<Permission>((e) => Permission.fromJson(e))
            .toList());
        if (remotePermissions.isNotEmpty) {
          await databaseService.syncPermissionToLocal(
            remotePermissions,
            userId,
          );
        }
      }
    } catch (e) {
      throw Exception('Error fetching permissions: $e');
    }
    try {
      return await databaseService.getPermissionsLocally(userId);
    } catch (e) {
      print("Gagal fetch local: $e");
      return remotePermissions;
    }
  }

  Future<void> syncOfflinePermissions() async {
    try {
      final unsyncedTasks = await databaseService.getUnsyncedPermissions();
      if (unsyncedTasks.isEmpty) return;
      print("${unsyncedTasks.length} permission untuk disinkronisasi.");

      print("Memulai Sync: ${unsyncedTasks.length} task...");

      for (var task in unsyncedTasks) {
        try {
          if (task.syncAction == 'insert') {
            await syncInsertToSupabase(task.toJson());
          } else if (task.syncAction == 'update' && task.id != null) {
            final data = task.toJson();
            data.remove('id');
            await syncUpdateToSupabase(task.id!, data);
          }
        } catch (e) {
          print("Gagal sync task ${task.id}: $e");
        }
      }
      print("Sync Selesai!");
    } catch (e) {
      print("Error Sync: $e");
    }
  }

  Future<void> insertPermission(Map<String, dynamic> data) async {
    if (connectivityService.isOnline.value) {
      await supabase.from('permissions').insert(data);
    } else {
      await databaseService.addPermissionToSyncQueue(data, 'insert');
    }
  }

  Future<void> updatePermission(int id, Map<String, dynamic> data) async {
    await supabase.from('permissions').update(data).eq('id', id);
  }

  Future<void> syncInsertToSupabase(Map<String, dynamic> json) async {
    try {
      final Map<String, dynamic> supabaseData = Map.from(json);
      supabaseData.remove('id');
      supabaseData.remove('is_synced');
      supabaseData.remove('sync_action');

      final response = await supabase
          .from(ApiConstant.tablePermissions)
          .insert(supabaseData)
          .select()
          .single();
      final remoteId = response['id'];
      print("Background: Berhasil kirim ke Supabase!");

      final db = await databaseService.database;
      await db.update(
        ApiConstant.tablePermissions,
        {'id': remoteId, 'is_synced': 1, 'sync_action': null},
        where: 'created_at = ? AND user_id = ?',
        whereArgs: [json['created_at'], json['user_id']],
      );
    } catch (e) {
      print("Background: Gagal ke Supabase (akan disync nanti): $e");
    }
  }

  Future<void> syncUpdateToSupabase(int i, Map<String, dynamic> data) async {
    try {
      final Map<String, dynamic> supabaseData = Map.from(data)
        ..remove('id')
        ..remove('is_synced')
        ..remove('sync_action');

      await supabase
          .from(ApiConstant.tablePermissions)
          .update(supabaseData)
          .eq('id', i);
      print("Background: Berhasil kirim ke Supabase!");

      final db = await databaseService.database;
      await db.update(
        ApiConstant.tablePermissions,
        {'is_synced': 1, 'sync_action': null},
        where: 'created_at = ? AND user_id = ?',
        whereArgs: [data['created_at'], data['user_id']],
      );
    } catch (e) {
      print("Background: Gagal ke Supabase (akan disync nanti): $e");
    }
  }

  Future<void> syncDeleteToSupabase(int i) async {
    try {
      await supabase.from(ApiConstant.tablePermissions).delete().eq('id', i);
      await databaseService.deletePermissionLocally(i);
      print("Background: Berhasil hapus ke Supabase!");
    } catch (e) {
      print("Background: Gagal ke Supabase (akan disync nanti): $e");
    }
  }
}
