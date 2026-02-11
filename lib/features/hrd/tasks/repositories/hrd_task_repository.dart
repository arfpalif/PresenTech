import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/constants/api_constant.dart';
import 'package:presentech/shared/models/tasks.dart';
import 'package:presentech/shared/view/components/snackbar/failed_snackbar.dart';
import 'package:presentech/shared/view/components/snackbar/success_snackbar.dart';
import 'package:presentech/utils/database/dao/task_dao.dart';
import 'package:presentech/utils/services/connectivity_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HrdTaskRepository {
  final SupabaseClient supabase = Supabase.instance.client;
  RxList<Tasks> tasks = <Tasks>[].obs;
  final ConnectivityService connectivityService =
      Get.find<ConnectivityService>();
  final TaskDao _taskDao = Get.find<TaskDao>();

  Future<List<Tasks>> fetchTasks() async {
    List<Tasks> remoteTasks = [];

    try {
      if (connectivityService.isOnline.value) {
        final response = await supabase
            .from(ApiConstant.tableTasks)
            .select('*, users(name)')
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
      final localData = await _taskDao.getAllTasks();
      return localData.map((e) => Tasks.fromDrift(e)).toList();
    } catch (e) {
      debugPrint("Gagal fetch local: $e");
      return remoteTasks;
    }
  }

  Future<bool> insertTask(Tasks task) async {
    try {
      await supabase.from('tasks').insert(task.toJson());
      await fetchTasks();
      return true;
    } catch (e) {
      print("Error insertTask: $e");
      FailedSnackbar.show("Gagal menambahkan tugas: ${e.toString()}");
      return false;
    }
  }

  Future<bool> updateTask(Tasks task) async {
    try {
      await supabase.from('tasks').update(task.toJson()).eq('id', task.id!);
      await fetchTasks();
      return true;
    } catch (e) {
      print("Error updateTask: $e");
      FailedSnackbar.show("Gagal memperbarui tugas: ${e.toString()}");
      return false;
    }
  }

  Future<bool> deleteTask(int id) async {
    try {
      await supabase.from('tasks').delete().eq('id', id);
      tasks.removeWhere((t) => t.id == id);
      SuccessSnackbar.show("Tugas berhasil dihapus");
      return true;
    } catch (e) {
      print("Error deleteTask: $e");
      FailedSnackbar.show("Gagal menghapus tugas: ${e.toString()}");
      return false;
    }
  }

  Future<bool> updateTaskStatus(int id, String status) async {
    try {
      await supabase.from('tasks').update({'status': status}).eq('id', id);
      await fetchTasks();
      return true;
    } catch (e) {
      throw ("Error updateTaskStatus: $e");
    }
  }
}
