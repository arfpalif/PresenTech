import 'package:presentech/features/employee/tasks/domain/repositories/user_session_repository.dart';

class GetCurrentUserIdUseCase {
  final UserSessionRepository _repository;

  GetCurrentUserIdUseCase(this._repository);

  String? call() {
    return _repository.getCurrentUserId();
  }
}
