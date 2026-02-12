import 'package:presentech/features/employee/tasks/domain/repositories/employee_task_repository.dart';
import 'package:presentech/shared/models/tasks.dart';

class UpdateTaskUseCase {
  final EmployeeTaskRepository _repository;

  UpdateTaskUseCase(this._repository);

  Future<void> call(int id, Tasks task) {
    return _repository.updateTask(id, task);
  }
}
