import 'package:path/path.dart';
import 'package:presentech/constants/api_constant.dart';
import 'package:presentech/shared/models/absence.dart';
import 'package:presentech/shared/models/permission.dart';
import 'package:presentech/shared/models/tasks.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._constructor();

  DatabaseService._constructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await getDatabase();
      return _database!;
    }
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final path = join(databaseDirPath, 'app_database.db');
    print("DatabaseService: Opening database at $path");

    final database = await openDatabase(
      path,
      onCreate: (db, version) async {
        print("DatabaseService: onCreate version $version");
        print("DatabaseService: onCreate version $version");
        await db.execute('''
          CREATE TABLE ${ApiConstant.tableAbsences}(
            id INTEGER PRIMARY KEY,       
            user_id TEXT NOT NULL,

            date TEXT NOT NULL,           
            clock_in TEXT,                
            clock_out TEXT,              

            status TEXT NOT NULL,

            created_at TEXT NOT NULL,

            is_synced INTEGER DEFAULT 0,  
            sync_action TEXT   
          )
        ''');
        await db.execute('''
          CREATE TABLE ${ApiConstant.tableTasks}(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT NOT NULL,
            title TEXT NOT NULL,
            acceptance_criteria TEXT,
            start_date TEXT,
            end_date TEXT,
            priority TEXT,
            level TEXT,
            status TEXT,
            created_at TEXT NOT NULL,
            is_synced INTEGER DEFAULT 0,
            sync_action TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE ${ApiConstant.tablePermissions}(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT NOT NULL,
            type TEXT NOT NULL,
            reason TEXT NOT NULL,
            start_date TEXT NOT NULL,
            end_date TEXT NOT NULL,
            status TEXT NOT NULL,
            feedback TEXT,
            created_at TEXT NOT NULL,
            is_synced INTEGER DEFAULT 0,
            sync_action TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE ${ApiConstant.tableOffices}(
            id INTEGER PRIMARY KEY,
            created_at TEXT,
            name TEXT,
            address TEXT,
            latitude REAL,
            longitude REAL,
            radius REAL,
            start_time TEXT,
            end_time TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS ${ApiConstant.tableAuth}(
            id TEXT PRIMARY KEY,
            email TEXT,
            role TEXT,
            last_login TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS ${ApiConstant.tableUsers}(
            id TEXT PRIMARY KEY,
            name TEXT,
            email TEXT,
            role TEXT,
            profile_picture TEXT,
            office_id INTEGER,
            created_at TEXT,
            is_synced INTEGER DEFAULT 1,
            sync_action TEXT,
            local_image_path TEXT
          )
        ''');
      },

      onUpgrade: (db, oldVersion, newVersion) async {
        print("DatabaseService: onUpgrade from $oldVersion to $newVersion");
        if (oldVersion < 2) {}
        if (oldVersion < 3) {
          await db.execute('''
          CREATE TABLE ${ApiConstant.tableAbsences}(
            id INTEGER PRIMARY KEY,       
            user_id TEXT NOT NULL,

            date TEXT NOT NULL,           
            clock_in TEXT,                
            clock_out TEXT,              

            status TEXT NOT NULL,

            created_at TEXT NOT NULL,

            is_synced INTEGER DEFAULT 0,  
            sync_action TEXT   
          )
        ''');
          await db.execute('''
            CREATE TABLE IF NOT EXISTS ${ApiConstant.tableTasks}(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              user_id TEXT NOT NULL,
              title TEXT NOT NULL,
              acceptance_criteria TEXT,
              start_date TEXT,
              end_date TEXT,
              priority TEXT,
              level TEXT,
              status TEXT,
              created_at TEXT NOT NULL,
              is_synced INTEGER DEFAULT 0,
              sync_action TEXT
            )
          ''');
          await db.execute('''
            CREATE TABLE IF NOT EXISTS ${ApiConstant.tablePermissions}(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              user_id TEXT NOT NULL,
              type TEXT NOT NULL,
              reason TEXT NOT NULL,
              start_date TEXT NOT NULL,
              end_date TEXT NOT NULL,
              status TEXT NOT NULL,
              feedback TEXT,
              created_at TEXT NOT NULL,
              is_synced INTEGER DEFAULT 0,
              sync_action TEXT
            )
          ''');
        }

        if (oldVersion < 6) {
          print(
            "DatabaseService: Upgrading to version 6 - ensuring auth table exists",
          );
          await db.execute('''
            CREATE TABLE IF NOT EXISTS ${ApiConstant.tableAuth}(
              id TEXT PRIMARY KEY,
              email TEXT,
              role TEXT,
              last_login TEXT
            )
          ''');
        }
        if (oldVersion < 7) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS ${ApiConstant.tableUsers}(
              id TEXT PRIMARY KEY,
              email TEXT,
              role TEXT,
              last_login TEXT
            )
          ''');
        }
        if (oldVersion < 8) {
          print(
            "DatabaseService: Upgrading to version 8 - ensuring users table has sync columns",
          );
          final columns = [
            'name TEXT',
            'profile_picture TEXT',
            'office_id INTEGER',
            'created_at TEXT',
            'is_synced INTEGER DEFAULT 1',
            'sync_action TEXT',
            'local_image_path TEXT',
          ];

          for (var col in columns) {
            try {
              await db.execute(
                'ALTER TABLE ${ApiConstant.tableUsers} ADD COLUMN $col',
              );
            } catch (e) {
              print(
                "DatabaseService: Column already exists or error adding $col: $e",
              );
            }
          }
        }
        if (oldVersion < 12) {
          print(
            "DatabaseService: Upgrading to version 12 - adding offices table if not exists",
          );
          await db.execute('''
            CREATE TABLE IF NOT EXISTS ${ApiConstant.tableOffices}(
              id INTEGER PRIMARY KEY,
              name TEXT,
              address TEXT,
              latitude REAL,
              longitude REAL,
              radius REAL,
              created_at TEXT,
              start_time TEXT,
              end_time TEXT
            )
          ''');
        }

        if (oldVersion < 13) {
          print(
            "DatabaseService: Upgrading to version 13 - adding start_time and end_time to offices",
          );
          try {
            await db.execute(
              'ALTER TABLE ${ApiConstant.tableOffices} ADD COLUMN start_time TEXT',
            );
            await db.execute(
              'ALTER TABLE ${ApiConstant.tableOffices} ADD COLUMN end_time TEXT',
            );
          } catch (e) {
            print("DatabaseService: Error adding hours to offices: $e");
          }
        }
      },
      version: 13,
    );
    return database;
  }

  //Auth Sync Queue
  Future<Map<String, dynamic>?> getAuthData() async {
    final db = await database;
    try {
      final results = await db.query(ApiConstant.tableAuth, limit: 1);
      print("DatabaseService: Found ${results.length} local auth records");
      if (results.isNotEmpty) {
        return results.first;
      }
    } catch (e) {
      print("DatabaseService Error getAuthData: $e");
    }
    return null;
  }

  Future<void> saveAuthData(Map<String, dynamic> authData) async {
    final db = await database;
    print("DatabaseService: Saving auth data for ${authData['email']}");
    await db.insert(
      ApiConstant.tableAuth,
      authData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> clearAuthData() async {
    final db = await database;
    await db.delete(ApiConstant.tableAuth);
  }

  //Absence Sync Queue
  Future<int> addAbsenceToSyncQueue(
    Map<String, dynamic> absenceData,
    String action,
  ) async {
    final db = await database;

    absenceData['is_synced'] = 0;
    absenceData['sync_action'] = action;

    return await db.insert(
      ApiConstant.tableAbsences,
      absenceData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> markAbsenceAsSynced(String userId, String date) async {
    final db = await database;
    await db.update(
      ApiConstant.tableAbsences,
      {'is_synced': 1, 'sync_action': null},
      where: 'user_id = ? AND date = ?',
      whereArgs: [userId, date],
    );
  }

  Future<List<Absence>> getUnsyncedAbsences() async {
    final db = await database;
    final results = await db.query(
      ApiConstant.tableAbsences,
      where: 'is_synced = ?',
      whereArgs: [0],
    );

    return results.map((e) => Absence.fromJson(e)).toList();
  }

  Future<List<Absence>> getAbsencesLocally(String userId) async {
    final db = await database;
    final results = await db.query(
      ApiConstant.tableAbsences,
      where: 'user_id = ? AND (sync_action IS NULL OR sync_action != ?)',
      whereArgs: [userId, 'delete'],
      orderBy: 'created_at DESC',
    );
    return results.map((e) => Absence.fromJson(e)).toList();
  }

  Future<void> syncAbsenceToLocal(List<Absence> absences, String userId) async {
    final db = await database;
    final batch = db.batch();

    for (var absence in absences) {
      final absenceData = absence.toJson();
      absenceData['user_id'] = userId;
      absenceData['is_synced'] = 1;
      absenceData['sync_action'] = null;
      absenceData['id'] = absence.id;

      batch.insert(
        ApiConstant.tableAbsences,
        absenceData,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
    print("Berhasil sinkronisasi ${absences.length} absence ke local.");
  }

  Future<Map<String, dynamic>?> getAbsenceByDateLocally(
    String userId,
    String date,
  ) async {
    final db = await database;
    final result = await db.query(
      ApiConstant.tableAbsences,
      where: 'user_id = ? AND date = ?',
      whereArgs: [userId, date],
    );
    return result.isNotEmpty ? result.first : null;
  }

  //Permission Sync Queue
  Future<int> addPermissionToSyncQueue(
    Map<String, dynamic> permissionData,
    String action,
  ) async {
    final db = await database;

    permissionData['is_synced'] = 0;
    permissionData['sync_action'] = action;

    return await db.insert(
      ApiConstant.tablePermissions,
      permissionData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Permission>> getUnsyncedPermissions() async {
    final db = await database;
    final results = await db.query(
      ApiConstant.tablePermissions,
      where: 'is_synced = ?',
      whereArgs: [0],
    );

    return results.map((e) => Permission.fromJson(e)).toList();
  }

  Future<List<Permission>> getPermissionsLocally(String userId) async {
    final db = await database;
    final results = await db.query(
      ApiConstant.tablePermissions,
      where: 'user_id = ? AND (sync_action IS NULL OR sync_action != ?)',
      whereArgs: [userId, 'delete'],
      orderBy: 'created_at DESC',
    );
    return results.map((e) => Permission.fromJson(e)).toList();
  }

  Future<void> syncPermissionToLocal(
    List<Permission> permissions,
    String userId,
  ) async {
    final db = await database;
    final batch = db.batch();

    for (var permission in permissions) {
      final permissionData = permission.toJson();
      permissionData['user_id'] = userId;
      permissionData['is_synced'] = 1;
      permissionData['sync_action'] = null;

      batch.insert(
        ApiConstant.tablePermissions,
        permissionData,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
    print("Berhasil sinkronisasi ${permissions.length} permission ke local.");
  }

  Future<void> deletePermissionLocally(int id) async {
    final db = await database;
    await db.delete(
      ApiConstant.tablePermissions,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Future<void> markPermissionAsDeleted(int id) async {
  //   final db = await database;
  //   await db.update(
  //     ApiConstant.tablePermissions,
  //     {'is_synced': 0, 'sync_action': 'delete'},
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );
  // }

  //Task Sync Queue
  Future<int> addTaskToSyncQueue(
    Map<String, dynamic> taskData,
    String action,
  ) async {
    final db = await database;

    taskData['is_synced'] = 0;
    taskData['sync_action'] = action;

    return await db.insert(
      ApiConstant.tableTasks,
      taskData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Tasks>> getTasksLocally(String userId) async {
    final db = await database;
    final results = await db.query(
      ApiConstant.tableTasks,
      where: 'user_id = ? AND (sync_action IS NULL OR sync_action != ?)',
      whereArgs: [userId, 'delete'],
      orderBy: 'created_at DESC',
    );
    return results.map((e) => Tasks.fromJson(e)).toList();
  }

  Future<void> syncTasksToLocal(List<Tasks> tasks, String userId) async {
    final db = await database;
    final batch = db.batch();

    for (var task in tasks) {
      final taskData = task.toJson();
      taskData['user_id'] = userId;
      taskData['is_synced'] = 1;
      taskData['sync_action'] = null;

      if (task.id != null) {
        taskData['id'] = task.id;
      }

      batch.insert(
        ApiConstant.tableTasks,
        taskData,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
    print("Berhasil sinkronisasi ${tasks.length} task ke local.");
  }

  Future<void> deleteTaskLocally(int id) async {
    final db = await database;
    await db.delete(ApiConstant.tableTasks, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> markTaskAsDeleted(int id) async {
    final db = await database;
    await db.update(
      ApiConstant.tableTasks,
      {'is_synced': 0, 'sync_action': 'delete'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Tasks>> getUnsyncedTasks() async {
    final db = await database;
    final results = await db.query(
      ApiConstant.tableTasks,
      where: 'is_synced = ?',
      whereArgs: [0],
    );
    print(results);

    return results.map((e) => Tasks.fromJson(e)).toList();
  }

  Future<void> debugPrintTasks() async {
    final db = await database;
    final results = await db.query(ApiConstant.tableTasks);

    print("--- ISI BUKU CATATAN (SQLITE) ---");
    if (results.isEmpty) {
      print("Kosong Melompong!");
    } else {
      for (var row in results) {
        print(row);
      }
    }
  }

  Future<Map<String, dynamic>?> getProfileLocally(String userId) async {
    final db = await database;
    final results = await db.query(
      ApiConstant.tableUsers,
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> saveProfileLocally(Map<String, dynamic> profileData) async {
    final db = await database;
    await db.insert(
      ApiConstant.tableUsers,
      profileData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> syncUserToLocal(
    Map<String, dynamic> userData,
    String userId,
  ) async {
    final db = await database;

    final existing = await getProfileLocally(userId);
    if (existing != null && existing['local_image_path'] != null) {
      userData['local_image_path'] = existing['local_image_path'];
    }

    userData['id'] = userId;
    userData['is_synced'] = 1;
    userData['sync_action'] = null;

    await db.insert(
      ApiConstant.tableUsers,
      userData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(
      "Berhasil sinkronisasi profile user ke local (local_image_path preserved).",
    );
  }

  Future<List<Map<String, dynamic>>> getUnsyncedProfiles() async {
    final db = await database;
    return await db.query(
      ApiConstant.tableUsers,
      where: 'is_synced = ?',
      whereArgs: [0],
    );
  }

  Future<void> markProfileAsSynced(String userId) async {
    final db = await database;
    await db.update(
      ApiConstant.tableUsers,
      {'is_synced': 1, 'sync_action': null},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<Map<String, dynamic>?> getOfficeLocallyById(int officeId) async {
    final db = await database;
    final results = await db.query(
      ApiConstant.tableOffices,
      where: 'id = ?',
      whereArgs: [officeId],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> saveOfficeLocally(Map<String, dynamic> officeData) async {
    final db = await database;
    await db.insert(
      ApiConstant.tableOffices,
      officeData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
