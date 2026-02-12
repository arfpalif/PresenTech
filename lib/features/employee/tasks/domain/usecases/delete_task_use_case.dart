import 'package:presentech/features/employee/tasks/domain/repositories/employee_task_repository.dart';

class DeleteTaskUseCase {
  final EmployeeTaskRepository _repository;

  DeleteTaskUseCase(this._repository);

  Future<void> call(int id) {
    return _repository.deleteTask(id);
  }
}
