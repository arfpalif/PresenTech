import 'package:presentech/features/employee/tasks/domain/repositories/employee_task_repository.dart';
import 'package:presentech/shared/models/tasks.dart';

class FetchTasksUseCase {
  final EmployeeTaskRepository _repository;

  FetchTasksUseCase(this._repository);

  Future<List<Tasks>> call(String userId) {
    return _repository.fetchTasks(userId);
  }
}
