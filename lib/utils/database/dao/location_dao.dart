import 'package:drift/drift.dart';
import 'package:presentech/utils/database/database.dart';

part 'location_dao.g.dart';

@DriftAccessor(tables: [LocationsTable])
class LocationDao extends DatabaseAccessor<AppDatabase>
    with _$LocationDaoMixin {
  LocationDao(super.db);

  Future<List<LocationsTableData>> getUnsyncedLocations() {
    return (select(locationsTable)..where((t) => t.isSynced.equals(false))).get();
  }

  Future<void> markAsSynced(int oldId, int newId) async {
    await (update(locationsTable)..where((t) => t.id.equals(oldId))).write(
      LocationsTableCompanion(
        id: Value(newId),
        isSynced: const Value(true),
        syncAction: const Value(null),
      ),
    );
  }

  Future<void> syncOfficesToLocal(List<LocationsTableCompanion> offices) async {
    await transaction(() async {
      await (delete(locationsTable)..where((t) => t.isSynced.equals(true))).go();
      for (final companion in offices) {
        await into(locationsTable).insertOnConflictUpdate(companion);
      }
    });
  }

  Future<int> insertLocation(LocationsTableCompanion companion) {
    return into(locationsTable).insertOnConflictUpdate(companion);
  }

  Future<void> updateLocation(int id, LocationsTableCompanion companion) {
    return (update(locationsTable)..where((t) => t.id.equals(id))).write(companion);
  }
}
