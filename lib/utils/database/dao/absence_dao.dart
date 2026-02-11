import 'package:drift/drift.dart';
import 'package:presentech/shared/models/absence.dart';
import '../database.dart';

part 'absence_dao.g.dart';

@DriftAccessor(tables: [AbsencesTable])
class AbsenceDao extends DatabaseAccessor<AppDatabase> with _$AbsenceDaoMixin {
  AbsenceDao(super.db);

  Future<List<AbsencesTableData>> getAbsencesByUser(String userId) =>
      (select(absencesTable)
            ..where((t) => t.userId.equals(userId))
            ..orderBy([
              (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
            ]))
          .get();

  Future<List<AbsencesTableData>> getAbsencesByRange(
    String userId,
    DateTime start,
    DateTime end,
  ) =>
      (select(absencesTable)
            ..where(
              (t) =>
                  t.userId.equals(userId) &
                  t.date.isBiggerOrEqualValue(start) &
                  t.date.isSmallerOrEqualValue(end),
            )
            ..orderBy([
              (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
            ]))
          .get();

  Future<AbsencesTableData?> getAbsenceByDate(
    String userId,
    String date,
  ) async {
    final dateObj = DateTime.parse(date);
    final results = await (select(
      absencesTable,
    )..where((t) => t.userId.equals(userId) & t.date.equals(dateObj))).get();
    return results.isNotEmpty ? results.first : null;
  }

  Future<List<AbsencesTableData>> getAllAbsences() =>
      (select(absencesTable)..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
          ]))
          .get();

  Future<int> insertAbsence(Absence absence) =>
      into(absencesTable).insertOnConflictUpdate(absence.toDrift());

  Future<bool> updateAbsence(AbsencesTableCompanion absence) =>
      update(absencesTable).replace(absence);

  Future<void> syncAbsenceToLocal(List<AbsencesTableCompanion> absences) async {
    await batch(
      (b) => b.insertAll(
        absencesTable,
        absences,
        mode: InsertMode.insertOrReplace,
      ),
    );
  }

  Future<List<AbsencesTableData>> getUnsyncedAbsences() =>
      (select(absencesTable)..where((t) => t.isSynced.equals(0))).get();

  Future<void> markAbsenceAsSynced(String userId, String date) async {
    final dateObj = DateTime.parse(date);
    await (update(
      absencesTable,
    )..where((t) => t.userId.equals(userId) & t.date.equals(dateObj))).write(
      const AbsencesTableCompanion(isSynced: Value(1), syncAction: Value(null)),
    );
  }
}
