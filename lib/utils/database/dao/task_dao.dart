import 'package:drift/drift.dart';
import '../database.dart';

part 'task_dao.g.dart';

@DriftAccessor(tables: [TasksTable])
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  TaskDao(AppDatabase db) : super(db);

  Future<List<TasksTableData>> getTasksByUser(String userId) {
    return (select(tasksTable)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  Future<List<TasksTableData>> getAllTasks() {
    return (select(tasksTable)..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
        ]))
        .get();
  }

  Future<List<TasksTableData>> getUnsyncedTasks() {
    return (select(tasksTable)..where((t) => t.isSynced.equals(0))).get();
  }

  Future<TasksTableData?> getTaskById(int id) {
    return (select(
      tasksTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertTask(TasksTableCompanion task) {
    return into(tasksTable).insert(task);
  }

  Future<bool> updateTaskSyncStatus(int id, int isSynced, String? syncAction) {
    return (update(tasksTable)..where((t) => t.id.equals(id)))
        .write(
          TasksTableCompanion(
            isSynced: Value(isSynced),
            syncAction: Value(syncAction),
          ),
        )
        .then((rows) => rows > 0);
  }

  Future<bool> updateTaskData(int id, TasksTableCompanion task) {
    return (update(
      tasksTable,
    )..where((t) => t.id.equals(id))).write(task).then((rows) => rows > 0);
  }

  Future<int> deleteTaskLocally(int id) {
    return (delete(tasksTable)..where((t) => t.id.equals(id))).go();
  }

  Future<void> syncTasksToLocal(List<TasksTableCompanion> tasks) async {
    await batch((batch) {
      for (var task in tasks) {
        batch.insert(tasksTable, task, mode: InsertMode.insertOrReplace);
      }
    });
  }
}
