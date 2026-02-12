import 'package:flutter/material.dart';
import 'package:presentech/features/employee/tasks/data/datasources/task_local_data_source.dart';
import 'package:presentech/features/employee/tasks/data/datasources/task_remote_data_source.dart';
import 'package:presentech/features/employee/tasks/domain/repositories/employee_task_repository.dart';
import 'package:presentech/shared/models/tasks.dart';
import 'package:presentech/utils/services/connectivity_service.dart';

class EmployeeTaskRepositoryImpl implements EmployeeTaskRepository {
  final TaskRemoteDataSource _remoteDataSource;
  final TaskLocalDataSource _localDataSource;
  final ConnectivityService _connectivityService;

  EmployeeTaskRepositoryImpl({
    required TaskRemoteDataSource remoteDataSource,
    required TaskLocalDataSource localDataSource,
    required ConnectivityService connectivityService,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _connectivityService = connectivityService;

  static final Set<int> _syncingIds = {};
  static bool _isSyncingQueue = false;

  @override
  Future<List<Tasks>> fetchTasks(String userId) async {
    List<Tasks> remoteTasks = [];

    try {
      if (_connectivityService.isOnline.value) {
        final response = await _remoteDataSource.fetchTasks(userId);
        remoteTasks = response.map(Tasks.fromJson).toList();

        if (remoteTasks.isNotEmpty) {
          await _localDataSource.syncTasksToLocal(
            remoteTasks.map((task) => task.toDrift()).toList(),
          );
        }
      }
    } catch (e) {
      debugPrint('Gagal fetch Supabase: $e');
    }

    try {
      final localData = await _localDataSource.getTasksByUser(userId);
      return localData.map(Tasks.fromDrift).toList();
    } catch (e) {
      debugPrint('Gagal fetch local: $e');
      return remoteTasks;
    }
  }

  @override
  Future<void> syncOfflineTasks() async {
    if (_isSyncingQueue) return;
    _isSyncingQueue = true;

    try {
      final unsyncedData = await _localDataSource.getUnsyncedTasks();
      final unsyncedTasks = unsyncedData.map(Tasks.fromDrift).toList();

      if (unsyncedTasks.isEmpty) return;

      for (final task in unsyncedTasks) {
        try {
          if (task.id != null && _syncingIds.contains(task.id)) {
            continue;
          }

          if (task.syncAction == 'insert') {
            await _syncInsertToRemote(task.toJson());
          } else if (task.syncAction == 'update' && task.id != null) {
            final data = task.toJson()..remove('id');
            await _syncUpdateToRemote(task.id!, data);
          } else if (task.syncAction == 'delete' && task.id != null) {
            await _syncDeleteToRemote(task.id!);
          }
        } catch (e) {
          debugPrint('Gagal sync task ${task.id}: $e');
        }
      }
    } catch (e) {
      debugPrint('Error Sync: $e');
      throw Exception('Gagal Bulk Sync Tasks: $e');
    } finally {
      _isSyncingQueue = false;
    }
  }

  @override
  Future<int?> insertTask(Tasks task) async {
    final queuedTask = Tasks(
      createdAt: task.createdAt,
      acceptanceCriteria: task.acceptanceCriteria,
      startDate: task.startDate,
      endDate: task.endDate,
      priority: task.priority,
      level: task.level,
      id: task.id,
      title: task.title,
      userId: task.userId,
      userName: task.userName,
      status: task.status,
      isSynced: 0,
      syncAction: 'insert',
    );

    final localId = await _localDataSource.insertTask(queuedTask.toDrift());
    debugPrint('Task disimpan di HP dulu (insert - Mode Instan). ID: $localId');

    if (_connectivityService.isOnline.value) {
      _syncInsertToRemote({...task.toJson(), 'id': localId});
    }

    return localId;
  }

  @override
  Future<void> updateTask(int id, Tasks task) async {
    try {
      final queuedTask = Tasks(
        createdAt: task.createdAt,
        acceptanceCriteria: task.acceptanceCriteria,
        startDate: task.startDate,
        endDate: task.endDate,
        priority: task.priority,
        level: task.level,
        id: id,
        title: task.title,
        userId: task.userId,
        userName: task.userName,
        status: task.status,
        isSynced: 0,
        syncAction: 'update',
      );

      await _localDataSource.updateTaskData(id, queuedTask.toDrift());

      if (_connectivityService.isOnline.value) {
        _syncUpdateToRemote(id, task.toJson());
      }
    } catch (e) {
      debugPrint('Gagal update local: $e');
    }
  }

  @override
  Future<void> deleteTask(int id) async {
    try {
      final taskData = await _localDataSource.getTaskById(id);

      if (taskData == null) return;
      final isSynced = taskData.isSynced == 1;

      if (!isSynced) {
        await _localDataSource.deleteTaskLocally(id);
      } else {
        await _localDataSource.updateTaskSyncStatus(id, 0, 'delete');

        if (_connectivityService.isOnline.value) {
          _syncDeleteToRemote(id);
        }
      }
    } catch (e) {
      debugPrint('Gagal delete (Local): $e');
    }
  }

  Future<void> _syncInsertToRemote(Map<String, dynamic> data) async {
    final localId = data['id'];
    if (localId is int && _syncingIds.contains(localId)) return;
    if (localId is int) _syncingIds.add(localId);

    try {
      final supabaseData = Map<String, dynamic>.from(data)
        ..remove('id')
        ..remove('is_synced')
        ..remove('sync_action');

      final response = await _remoteDataSource.insertTask(supabaseData);
      final remoteId = response['id'] as int;

      if (localId is int) {
        await _localDataSource.deleteTaskLocally(localId);
        final syncedTask = Tasks.fromJson({...data, 'id': remoteId})
          ..isSynced = 1
          ..syncAction = null;
        await _localDataSource.insertTask(syncedTask.toDrift());
      }

      debugPrint('Background: Local ID updated to $remoteId');
    } catch (e) {
      debugPrint('Background: Gagal ke Supabase (akan disync nanti): $e');
    } finally {
      if (localId is int) _syncingIds.remove(localId);
    }
  }

  Future<void> _syncUpdateToRemote(int id, Map<String, dynamic> data) async {
    if (_syncingIds.contains(id)) return;
    _syncingIds.add(id);

    try {
      final supabaseData = Map<String, dynamic>.from(data)
        ..remove('id')
        ..remove('is_synced')
        ..remove('sync_action');

      await _remoteDataSource.updateTask(id, supabaseData);
      await _localDataSource.updateTaskSyncStatus(id, 1, null);
    } catch (e) {
      debugPrint('Background Update Gagal: $e');
    } finally {
      _syncingIds.remove(id);
    }
  }

  Future<void> _syncDeleteToRemote(int id) async {
    if (_syncingIds.contains(id)) return;
    _syncingIds.add(id);

    try {
      await _remoteDataSource.deleteTask(id);
      await _localDataSource.deleteTaskLocally(id);
      debugPrint(
        'Background: Task $id terhapus permanen dari Supabase & Local.',
      );
    } catch (e) {
      debugPrint('Background Delete Gagal (akan dicoba lagi nanti): $e');
    } finally {
      _syncingIds.remove(id);
    }
  }
}
