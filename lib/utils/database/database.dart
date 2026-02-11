import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:presentech/utils/database/dao/location_dao.dart';
import 'package:presentech/utils/database/dao/permission_dao.dart';
import 'package:presentech/utils/database/dao/profile_dao.dart';
import 'package:presentech/utils/database/dao/task_dao.dart';
import 'package:presentech/utils/database/dao/absence_dao.dart';

part 'database.g.dart';

class TodoItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 6, max: 32)();
  TextColumn get content => text().named('body')();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

class TasksTable extends Table {
  IntColumn get id => integer().autoIncrement().nullable()();
  TextColumn get userId => text()();
  TextColumn get title => text()();
  TextColumn get acceptanceCriteria => text().nullable()();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  TextColumn get priority => text().nullable()();
  TextColumn get level => text().nullable()();
  TextColumn get status => text().nullable()();
  TextColumn get createdAt => text()();
  IntColumn get isSynced => integer().withDefault(const Constant(0))();
  TextColumn get syncAction => text().nullable()();
}

class PermissionsTable extends Table {
  IntColumn get id => integer().autoIncrement().nullable()();
  TextColumn get userId => text()();
  TextColumn get type => text()();
  TextColumn get reason => text()();
  TextColumn get status => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  TextColumn get feedback => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get isSynced => integer().withDefault(const Constant(0))();
  TextColumn get syncAction => text().nullable()();
}

class AbsencesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get date => dateTime()();
  TextColumn get clockIn => text().nullable()();
  TextColumn get clockOut => text().nullable()();
  TextColumn get status => text().nullable()();
  TextColumn get userId => text()();
  TextColumn get userName => text().nullable()();
  IntColumn get isSynced => integer().withDefault(const Constant(0))();
  TextColumn get syncAction => text().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {userId, date},
  ];
}

class LocationsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().nullable()();
  TextColumn get address => text().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  RealColumn get radius => real().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  TextColumn get startTime => text().nullable()();
  TextColumn get endTime => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(true))();
  TextColumn get syncAction => text().nullable()();
}

class UsersTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get role => text().nullable()();
  TextColumn get profilePicture => text().nullable()();
  IntColumn get officeId => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  IntColumn get isSynced => integer().withDefault(const Constant(1))();
  TextColumn get syncAction => text().nullable()();
  TextColumn get localImagePath => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class EmployeesTable extends Table {
  TextColumn get userId => text()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  TextColumn get roles => text()();
  TextColumn get email => text()();
  TextColumn get name => text().nullable()();
  TextColumn get profilePicture => text().nullable()();
  IntColumn get officeId => integer().nullable()();
  TextColumn get officeName => text().nullable()();
  IntColumn get isSynced => integer().withDefault(const Constant(0))();
  TextColumn get syncAction => text().nullable()();

  @override
  Set<Column> get primaryKey => {userId};
}

@DriftDatabase(
  tables: [
    TodoItems,
    TasksTable,
    PermissionsTable,
    AbsencesTable,
    EmployeesTable,
    LocationsTable,
    UsersTable,
  ],
  daos: [TaskDao, PermissionDao, AbsenceDao, LocationDao, ProfileDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 8;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'my_database',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
