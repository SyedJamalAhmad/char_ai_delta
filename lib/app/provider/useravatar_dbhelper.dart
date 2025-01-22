import 'dart:io';

import 'package:character_ai_delta/app/data/user_avatar.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Import your model class

class UserAvatarDatabaseHelper {
  static final _databaseName = 'user_avatars.db';
  static final _tableName = 'avatars';

  UserAvatarDatabaseHelper._();
  static final UserAvatarDatabaseHelper db = UserAvatarDatabaseHelper._();

  // static Database? _database;

  // // Create the database table if it doesn't exist
  // static Future<void> createTable() async {
  //   final database = await _getDatabase();
  //   await database.execute(
  //     'CREATE TABLE IF NOT EXISTS $_tableName ('
  //     'id INTEGER PRIMARY KEY AUTOINCREMENT, '
  //     'imageAsset TEXT, '
  //     'avatarName TEXT, '
  //     'avatarFirstMessage TEXT, '
  //     'avatarDescription TEXT'
  //     ')',
  //   );
  // }

  // Get a reference to the database
  static Database? _database;

  Future<Database> get myDataBase async {
    if (_database != null) return _database!;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    print("Intializing DB....");
    String documentsDirectory = await getDatabasesPath();
    String path = join(documentsDirectory, "_databaseName");
    return await openDatabase(path, version: 3, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(
        'CREATE TABLE IF NOT EXISTS $_tableName ('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'imageAsset TEXT, '
        'avatarName TEXT, '
        'avatarFirstMessage TEXT, '
        'avatarDescription TEXT'
        ')',
      );
    });
  }
  // CRUD operations for UserPersonalizedAvatar objects

  // Insert a new avatar
  Future<void> insertAvatar(UserPersonalizedAvatar avatar) async {
    final database = await myDataBase;
    await database.insert(
      _tableName,
      avatar.toMap(),
      conflictAlgorithm:
          ConflictAlgorithm.replace, // Update if a duplicate exists
    );
  }

  // Get all avatars
  Future<List<UserPersonalizedAvatar>> getAvatars() async {
    final database = await myDataBase;
    final List<Map<String, dynamic>> maps = await database.query(_tableName);

    return List.generate(maps.length, (i) {
      return UserPersonalizedAvatar.fromMap(maps[i]);
    });
  }

  // Get a specific avatar by ID
  Future<UserPersonalizedAvatar?> getAvatarById(int id) async {
    final database = await myDataBase;
    final List<Map<String, dynamic>> maps = await database.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return UserPersonalizedAvatar.fromMap(maps[0]);
  }

  // Update an existing avatar
  Future<void> updateAvatar(UserPersonalizedAvatar avatar) async {
    final database = await myDataBase;
    await database.update(
      _tableName,
      avatar.toMap(),
      where: 'id = ?',
      whereArgs: [avatar.id],
    );
  }

  // Delete an avatar
  Future<void> deleteAvatar(int id) async {
    final database = await myDataBase;
    await database.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
