import 'package:drift/drift.dart';
import 'package:presentech/utils/database/database.dart';

part 'profile_dao.g.dart';

@DriftAccessor(tables: [UsersTable])
class ProfileDao extends DatabaseAccessor<AppDatabase> with _$ProfileDaoMixin {
  ProfileDao(super.db);

  Future<List<UsersTableData>> getUsers() {
    return select(usersTable).get();
  }

  Future<UsersTableData?> getProfileLocally(String id) {
    return (select(
      usersTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> saveProfile(UsersTableCompanion companion) {
    return into(usersTable).insertOnConflictUpdate(companion);
  }

  Future<List<UsersTableData>> getUnsyncedProfiles() {
    return (select(usersTable)..where((t) => t.isSynced.equals(0))).get();
  }

  Future<void> markProfileAsSynced(String id) {
    return (update(usersTable)..where((t) => t.id.equals(id))).write(
      const UsersTableCompanion(isSynced: Value(1), syncAction: Value(null)),
    );
  }
}
