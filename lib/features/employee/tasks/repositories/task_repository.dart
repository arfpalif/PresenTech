import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/constants/api_constant.dart';
import 'package:presentech/shared/models/tasks.dart';
import 'package:presentech/utils/services/connectivity_service.dart';
import 'package:presentech/utils/database/dao/task_dao.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TaskRepository {
  final SupabaseClient supabase = Supabase.instance.client;
  final ConnectivityService connectivityService =
      Get.find<ConnectivityService>();
  final TaskDao _taskDao = Get.find<TaskDao>();

  static final Set<int> _syncingIds = {};
  static bool _isSyncingQueue = false;

  Future<List<Tasks>> fetchTasks(String userId) async {
    List<Tasks> remoteTasks = [];

    try {
      if (connectivityService.isOnline.value) {
        final response = await supabase
            .from(ApiConstant.tableTasks)
            .select()
            .eq('user_id', userId)
            .order('id', ascending: false);
        remoteTasks = (response as List).map((e) => Tasks.fromJson(e)).toList();

        if (remoteTasks.isNotEmpty) {
          await _taskDao.syncTasksToLocal(
            remoteTasks.map((t) => t.toDrift()).toList(),
          );
        }
      }
    } catch (e) {
      debugPrint("Gagal fetch Supabase: $e");
    }

    try {
      final localData = await _taskDao.getTasksByUser(userId);
      return localData.map((e) => Tasks.fromDrift(e)).toList();
    } catch (e) {
      debugPrint("Gagal fetch local: $e");
      return remoteTasks;
    }
  }

  Future<void> syncOfflineTasks() async {
    if (_isSyncingQueue) return;
    _isSyncingQueue = true;

    try {
      final unsyncedData = await _taskDao.getUnsyncedTasks();
      final unsyncedTasks = unsyncedData
          .map((e) => Tasks.fromDrift(e))
          .toList();

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
          debugPrint("Gagal sync task ${task.id}: $e");
        }
      }
    } catch (e) {
      debugPrint("Error Sync: $e");
      throw Exception("Gagal Bulk Sync Tasks: $e");
    } finally {
      _isSyncingQueue = false;
    }
  }

  Future<int?> insertTask(Map<String, dynamic> data) async {
    final task = Tasks.fromJson(data);
    task.isSynced = 0;
    task.syncAction = 'insert';

    final localId = await _taskDao.insertTask(task.toDrift());
    debugPrint("Task disimpan di HP dulu (insert - Mode Instan). ID: $localId");

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
      debugPrint(
        "Background: Berhasil kirim ke Supabase! Remote ID: $remoteId",
      );

      if (localId != null) {
        await _taskDao.deleteTaskLocally(localId);
        final task = Tasks.fromJson(data);
        task.id = remoteId;
        task.isSynced = 1;
        task.syncAction = null;
        await _taskDao.insertTask(task.toDrift());
      }
      debugPrint("Background: Local ID updated to $remoteId");
    } catch (e) {
      debugPrint("Background: Gagal ke Supabase (akan disync nanti): $e");
    } finally {
      if (localId != null) _syncingIds.remove(localId);
    }
  }

  Future<void> updateTask(int id, Map<String, dynamic> data) async {
    try {
      final task = Tasks.fromJson(data);
      task.id = id;
      task.isSynced = 0;
      task.syncAction = 'update';

      await _taskDao.updateTaskData(id, task.toDrift());

      if (connectivityService.isOnline.value) {
        _syncUpdateToSupabase(id, data);
      }
    } catch (e) {
      debugPrint("Gagal update local: $e");
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

      await _taskDao.updateTaskSyncStatus(id, 1, null);
    } catch (e) {
      debugPrint("Background Update Gagal: $e");
    } finally {
      _syncingIds.remove(id);
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      final taskData = await _taskDao.getTaskById(id);

      if (taskData == null) return;
      final bool isSynced = taskData.isSynced == 1;

      if (!isSynced) {
        await _taskDao.deleteTaskLocally(id);
      } else {
        await _taskDao.updateTaskSyncStatus(id, 0, 'delete');

        if (connectivityService.isOnline.value) {
          _syncDeleteToSupabase(id);
        }
      }
    } catch (e) {
      debugPrint("Gagal delete (Local): $e");
    }
  }

  Future<void> _syncDeleteToSupabase(int id) async {
    if (_syncingIds.contains(id)) return;
    _syncingIds.add(id);

    try {
      await supabase.from(ApiConstant.tableTasks).delete().eq('id', id);
      await _taskDao.deleteTaskLocally(id);
      debugPrint(
        "Background: Task $id terhapus permanen dari Supabase & Local.",
      );
    } catch (e) {
      debugPrint("Background Delete Gagal (akan dicoba lagi nanti): $e");
    } finally {
      _syncingIds.remove(id);
    }
  }

  Future<void> syncPendingTasks() async {
    await syncOfflineTasks();
  }
}
