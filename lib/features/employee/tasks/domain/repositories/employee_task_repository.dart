import 'package:presentech/shared/models/tasks.dart';

abstract class EmployeeTaskRepository {
  Future<List<Tasks>> fetchTasks(String userId);
  Future<int?> insertTask(Tasks task);
  Future<void> updateTask(int id, Tasks task);
  Future<void> deleteTask(int id);
  Future<void> syncOfflineTasks();
}
