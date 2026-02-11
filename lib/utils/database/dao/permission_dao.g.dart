// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_dao.dart';

// ignore_for_file: type=lint
mixin _$PermissionDaoMixin on DatabaseAccessor<AppDatabase> {
  $PermissionsTableTable get permissionsTable =>
      attachedDatabase.permissionsTable;
  PermissionDaoManager get managers => PermissionDaoManager(this);
}

class PermissionDaoManager {
  final _$PermissionDaoMixin _db;
  PermissionDaoManager(this._db);
  $$PermissionsTableTableTableManager get permissionsTable =>
      $$PermissionsTableTableTableManager(
        _db.attachedDatabase,
        _db.permissionsTable,
      );
}
