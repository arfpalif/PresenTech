import 'package:presentech/features/employee/tasks/domain/repositories/employee_task_repository.dart';

class SyncOfflineTasksUseCase {
  final EmployeeTaskRepository _repository;

  SyncOfflineTasksUseCase(this._repository);

  Future<void> call() {
    return _repository.syncOfflineTasks();
  }
}
