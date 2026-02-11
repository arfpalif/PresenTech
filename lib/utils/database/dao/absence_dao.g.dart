// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'absence_dao.dart';

// ignore_for_file: type=lint
mixin _$AbsenceDaoMixin on DatabaseAccessor<AppDatabase> {
  $AbsencesTableTable get absencesTable => attachedDatabase.absencesTable;
  AbsenceDaoManager get managers => AbsenceDaoManager(this);
}

class AbsenceDaoManager {
  final _$AbsenceDaoMixin _db;
  AbsenceDaoManager(this._db);
  $$AbsencesTableTableTableManager get absencesTable =>
      $$AbsencesTableTableTableManager(_db.attachedDatabase, _db.absencesTable);
}
