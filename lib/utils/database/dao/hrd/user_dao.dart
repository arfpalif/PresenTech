import 'package:drift/drift.dart';
import 'package:presentech/features/employee/homepage/models/user.dart';
import '../../database.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [EmployeesTable])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(super.db);

  Future<List<EmployeesTableData>> getAllEmployees() => (select(
    employeesTable,
  )..orderBy([(t) => OrderingTerm(expression: t.name)])).get();

  Future<EmployeesTableData?> getEmployeeById(String userId) => (select(
    employeesTable,
  )..where((t) => t.userId.equals(userId))).getSingleOrNull();

  Future<void> syncEmployeesToLocal(
    List<EmployeesTableCompanion> employees,
  ) async {
    await batch(
      (b) => b.insertAll(
        employeesTable,
        employees,
        mode: InsertMode.insertOrReplace,
      ),
    );
  }

  Future<int> insertEmployee(UserModel user) =>
      into(employeesTable).insert(user.toDrift());

  Future<bool> updateEmployee(EmployeesTableCompanion employee) =>
      update(employeesTable).replace(employee);

  Future<void> updateEmployeeData(
    String userId,
    EmployeesTableCompanion companion,
  ) async {
    await (update(
      employeesTable,
    )..where((t) => t.userId.equals(userId))).write(companion);
  }

  Future<List<EmployeesTableData>> getUnsyncedEmployees() =>
      (select(employeesTable)..where((t) => t.isSynced.equals(0))).get();

  Future<void> markEmployeeAsSynced(String userId) async {
    await (update(employeesTable)..where((t) => t.userId.equals(userId))).write(
      const EmployeesTableCompanion(
        isSynced: Value(1),
        syncAction: Value(null),
      ),
    );
  }
}
