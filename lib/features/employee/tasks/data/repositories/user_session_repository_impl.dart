import 'package:presentech/features/employee/tasks/data/datasources/user_session_remote_data_source.dart';
import 'package:presentech/features/employee/tasks/domain/repositories/user_session_repository.dart';

class UserSessionRepositoryImpl implements UserSessionRepository {
  final UserSessionRemoteDataSource _remoteDataSource;

  UserSessionRepositoryImpl(this._remoteDataSource);

  @override
  String? getCurrentUserId() {
    return _remoteDataSource.getCurrentUserId();
  }
}
