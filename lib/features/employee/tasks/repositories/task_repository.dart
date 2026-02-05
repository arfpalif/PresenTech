import 'package:get/get.dart';
import 'package:presentech/constants/api_constant.dart';
import 'package:presentech/shared/models/tasks.dart';
import 'package:presentech/utils/services/connectivity_service.dart';
import 'package:presentech/utils/services/database_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TaskRepository {
  final SupabaseClient supabase = Supabase.instance.client;
  final ConnectivityService connectivityService =
      Get.find<ConnectivityService>();
  final DatabaseService databaseService = Get.find<DatabaseService>();

  static final Set<int> _syncingIds = {};
  static bool _isSyncingQueue = false;

  Future<List<Tasks>> fetchTasks(String userId) async {
    List<Tasks> remoteTasks = [];

    if (connectivityService.isOnline.value) {
      await syncOfflineTasks();
    }
    try {
      if (connectivityService.isOnline.value) {
        final response = await supabase
            .from(ApiConstant.tableTasks)
            .select()
            .eq('user_id', userId)
            .order('id', ascending: false);
        remoteTasks = (response as List).map((e) => Tasks.fromJson(e)).toList();

        if (remoteTasks.isNotEmpty) {
          await databaseService.syncTasksToLocal(remoteTasks, userId);
        }
      }
    } catch (e) {
      print("Gagal fetch Supabase: $e");
    }

    try {
      return await databaseService.getTasksLocally(userId);
    } catch (e) {
      print("Gagal fetch local: $e");
      return remoteTasks;
    }
  }

  Future<void> syncOfflineTasks() async {
    if (_isSyncingQueue) return;
    _isSyncingQueue = true;

    try {
      final unsyncedTasks = await databaseService.getUnsyncedTasks();
      if (unsyncedTasks.isEmpty) return;

      for (var task in unsyncedTasks) {
        try {
          if (task.id != null && _syncingIds.contains(task.id)) continue;

          if (task.syncAction == 'insert') {
            await _syncInsertToSupabase(task.toJson());
          } else if (task.syncAction == 'update' && task.id != null) {
            final data = task.toJson();
            data.remove('id');
            await _syncUpdateToSupabase(task.id!, data);
          } else if (task.syncAction == 'delete' && task.id != null) {
            await _syncDeleteToSupabase(task.id!);
          }
        } catch (e) {
          print("Gagal sync task ${task.id}: $e");
        }
      }
    } catch (e) {
      print("Error Sync: $e");
      throw Exception("Gagal Bulk Sync Tasks: $e");
    } finally {
      _isSyncingQueue = false;
    }
  }

  Future<int?> insertTask(Map<String, dynamic> data) async {
    final localId = await databaseService.addTaskToSyncQueue(data, 'insert');
    print("Task disimpan di HP dulu (insert - Mode Instan). ID: $localId");

    if (connectivityService.isOnline.value) {
      _syncInsertToSupabase({...data, 'id': localId});
    }
    return localId;
  }

  Future<void> _syncInsertToSupabase(Map<String, dynamic> data) async {
    final localId = data['id'];
    if (localId != null && _syncingIds.contains(localId)) return;
    if (localId != null) _syncingIds.add(localId);

    try {
      final Map<String, dynamic> supabaseData = Map.from(data);
      supabaseData.remove('id');
      supabaseData.remove('is_synced');
      supabaseData.remove('sync_action');

      final response = await supabase
          .from(ApiConstant.tableTasks)
          .insert(supabaseData)
          .select()
          .single();

      final remoteId = response['id'];
      print("Background: Berhasil kirim ke Supabase! Remote ID: $remoteId");

      final db = await databaseService.database;

      if (localId != null) {
        await db.update(
          ApiConstant.tableTasks,
          {'id': remoteId, 'is_synced': 1, 'sync_action': null},
          where: 'id = ?',
          whereArgs: [localId],
        );
      } else {
        await db.update(
          ApiConstant.tableTasks,
          {'id': remoteId, 'is_synced': 1, 'sync_action': null},
          where: 'created_at = ? AND user_id = ? AND title = ?',
          whereArgs: [data['created_at'], data['user_id'], data['title']],
        );
      }
      print("Background: Local ID updated to $remoteId");
    } catch (e) {
      print("Background: Gagal ke Supabase (akan disync nanti): $e");
    } finally {
      if (localId != null) _syncingIds.remove(localId);
    }
  }

  Future<void> updateTask(int id, Map<String, dynamic> data) async {
    try {
      final db = await databaseService.database;
      await db.update(
        ApiConstant.tableTasks,
        {...data, 'is_synced': 0, 'sync_action': 'update'},
        where: 'id = ?',
        whereArgs: [id],
      );

      if (connectivityService.isOnline.value) {
        _syncUpdateToSupabase(id, data);
      }
    } catch (e) {
      print("Gagal update local: $e");
    }
  }

  Future<void> _syncUpdateToSupabase(int id, Map<String, dynamic> data) async {
    if (_syncingIds.contains(id)) return;
    _syncingIds.add(id);

    try {
      final Map<String, dynamic> supabaseData = Map.from(data)
        ..remove('id')
        ..remove('is_synced')
        ..remove('sync_action');

      await supabase
          .from(ApiConstant.tableTasks)
          .update(supabaseData)
          .eq('id', id);
      final db = await databaseService.database;
      await db.update(
        ApiConstant.tableTasks,
        {'is_synced': 1, 'sync_action': null},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Background Update Gagal: $e");
    } finally {
      _syncingIds.remove(id);
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      final db = await databaseService.database;
      final taskData = await db.query(
        ApiConstant.tableTasks,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (taskData.isEmpty) return;
      final bool isSynced = taskData.first['is_synced'] == 1;

      if (!isSynced) {
        await databaseService.deleteTaskLocally(id);
      } else {
        await databaseService.markTaskAsDeleted(id);

        if (connectivityService.isOnline.value) {
          _syncDeleteToSupabase(id);
        }
      }
    } catch (e) {
      print("Gagal delete (Local): $e");
    }
  }

  Future<void> _syncDeleteToSupabase(int id) async {
    if (_syncingIds.contains(id)) return;
    _syncingIds.add(id);

    try {
      await supabase.from(ApiConstant.tableTasks).delete().eq('id', id);
      await databaseService.deleteTaskLocally(id);
      print("Background: Task $id terhapus permanen dari Supabase & Local.");
    } catch (e) {
      print("Background Delete Gagal (akan dicoba lagi nanti): $e");
    } finally {
      _syncingIds.remove(id);
    }
  }
}
