import 'package:presentech/utils/database/dao/task_dao.dart';
import 'package:presentech/utils/database/database.dart';

class TaskLocalDataSource {
  final TaskDao _taskDao;

  TaskLocalDataSource(this._taskDao);

  Future<List<TasksTableData>> getTasksByUser(String userId) {
    return _taskDao.getTasksByUser(userId);
  }

  Future<void> syncTasksToLocal(List<TasksTableCompanion> tasks) {
    return _taskDao.syncTasksToLocal(tasks);
  }

  Future<List<TasksTableData>> getUnsyncedTasks() {
    return _taskDao.getUnsyncedTasks();
  }

  Future<int> insertTask(TasksTableCompanion task) {
    return _taskDao.insertTask(task);
  }

  Future<void> updateTaskData(int id, TasksTableCompanion task) {
    return _taskDao.updateTaskData(id, task);
  }

  Future<void> updateTaskSyncStatus(int id, int isSynced, String? syncAction) {
    return _taskDao.updateTaskSyncStatus(id, isSynced, syncAction);
  }

  Future<TasksTableData?> getTaskById(int id) {
    return _taskDao.getTaskById(id);
  }

  Future<void> deleteTaskLocally(int id) {
    return _taskDao.deleteTaskLocally(id);
  }
}
