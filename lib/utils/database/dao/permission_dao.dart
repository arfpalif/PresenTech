import 'package:drift/drift.dart';
import 'package:presentech/utils/database/database.dart';

part 'permission_dao.g.dart';

@DriftAccessor(tables: [PermissionsTable])
class PermissionDao extends DatabaseAccessor<AppDatabase>
    with _$PermissionDaoMixin {
  PermissionDao(AppDatabase db) : super(db);

  Future<List<PermissionsTableData>> getPermissionsByUser(String userId) {
    return (select(permissionsTable)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  Future<List<PermissionsTableData>> getAllPermissions() {
    return (select(permissionsTable)..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)])).get();
  }

  Future<List<PermissionsTableData>> getUnsyncedPermissions() {
    return (select(permissionsTable)..where((t) => t.isSynced.equals(0))).get();
  }

  Future<int> insertPermission(PermissionsTableCompanion permission) {
    return into(permissionsTable).insert(permission);
  }

  Future<bool> updatePermissionSyncStatus(
    int id,
    int isSynced,
    String? syncAction,
  ) {
    return (update(permissionsTable)..where((t) => t.id.equals(id)))
        .write(
          PermissionsTableCompanion(
            isSynced: Value(isSynced),
            syncAction: Value(syncAction),
          ),
        )
        .then((rows) => rows > 0);
  }

  Future<bool> updatePermissionData(
    int id,
    PermissionsTableCompanion permission,
  ) {
    return (update(permissionsTable)..where((t) => t.id.equals(id)))
        .write(permission)
        .then((rows) => rows > 0);
  }

  Future<int> deletePermissionLocally(int id) {
    return (delete(permissionsTable)..where((t) => t.id.equals(id))).go();
  }

  Future<void> syncPermissionToLocal(
    List<PermissionsTableCompanion> permissions,
  ) async {
    final unsynced = await getUnsyncedPermissions();
    final unsyncedIds = unsynced.map((e) => e.id).toSet();

    await batch((batch) {
      for (var p in permissions) {
        if (p.id.present && !unsyncedIds.contains(p.id.value)) {
          batch.insert(permissionsTable, p, mode: InsertMode.insertOrReplace);
        }
      }
    });
  }

  Future<PermissionsTableData?> getPermissionById(int id) {
    return (select(
      permissionsTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }
}
