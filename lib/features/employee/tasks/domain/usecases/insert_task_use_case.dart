import 'package:presentech/features/employee/tasks/domain/repositories/employee_task_repository.dart';
import 'package:presentech/shared/models/tasks.dart';

class InsertTaskUseCase {
  final EmployeeTaskRepository _repository;

  InsertTaskUseCase(this._repository);

  Future<int?> call(Tasks task) {
    return _repository.insertTask(task);
  }
}
