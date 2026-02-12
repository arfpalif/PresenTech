import 'package:drift/drift.dart';
import '../database.dart';

part 'auth_dao.g.dart';

@DriftAccessor(tables: [AuthTable])
class AuthDao extends DatabaseAccessor<AppDatabase> with _$AuthDaoMixin {
  AuthDao(super.db);

  Future<AuthTableData?> getAuthData() async {
    return (select(authTable)..limit(1)).getSingleOrNull();
  }

  Future<int> saveAuthData(AuthTableCompanion companion) async {
    return into(authTable).insertOnConflictUpdate(companion);
  }

  Future<void> clearAuthData() async {
    await delete(authTable).go();
  }
}
