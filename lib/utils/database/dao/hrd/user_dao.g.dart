// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dao.dart';

// ignore_for_file: type=lint
mixin _$UserDaoMixin on DatabaseAccessor<AppDatabase> {
  $EmployeesTableTable get employeesTable => attachedDatabase.employeesTable;
  UserDaoManager get managers => UserDaoManager(this);
}

class UserDaoManager {
  final _$UserDaoMixin _db;
  UserDaoManager(this._db);
  $$EmployeesTableTableTableManager get employeesTable =>
      $$EmployeesTableTableTableManager(
        _db.attachedDatabase,
        _db.employeesTable,
      );
}
