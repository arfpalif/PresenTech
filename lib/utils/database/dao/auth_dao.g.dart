// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_dao.dart';

// ignore_for_file: type=lint
mixin _$AuthDaoMixin on DatabaseAccessor<AppDatabase> {
  $AuthTableTable get authTable => attachedDatabase.authTable;
  AuthDaoManager get managers => AuthDaoManager(this);
}

class AuthDaoManager {
  final _$AuthDaoMixin _db;
  AuthDaoManager(this._db);
  $$AuthTableTableTableManager get authTable =>
      $$AuthTableTableTableManager(_db.attachedDatabase, _db.authTable);
}
