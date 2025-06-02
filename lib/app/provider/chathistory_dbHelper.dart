import 'dart:developer' as developer;
import 'dart:io';

import 'package:character_ai_delta/app/data/db_message.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Import your model class

class ChatHistoryDatabaseHelper {
  static final _databaseName = 'charai_beta.db';
  static final _tableName = 'chat_history';

  ChatHistoryDatabaseHelper._();
  static final ChatHistoryDatabaseHelper db = ChatHistoryDatabaseHelper._();

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
    String path = join(documentsDirectory, "$_databaseName");
    return await openDatabase(path, version: 4, onOpen: (db) {},
        // onDowngrade: (db, oldVersion, newVersion) =>
        //     developer.log("Downgrading DB...."),
        onUpgrade: (Database db, int oldVersion, int newVersion) async {
      if (oldVersion < 4) {
        print("Upgrading DB....");
        await db.execute(
          '''
            ALTER TABLE $_tableName ADD COLUMN isVoiceResponse Integer NOT NULL DEFAULT 0
          ''',
        );
      }
    }, onCreate: (Database db, int version) async {
      await db.execute(
        '''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT NOT NULL,
            character_id TEXT NOT NULL,
            message TEXT NOT NULL,
            type TEXT NOT NULL,
            isVoiceResponse Integer NOT NULL DEFAULT 0
          )
        ''',
      );
    });
  }
  // CRUD operations for UserPersonalizedAvatar objects

  // Insert a new avatar
  Future<void> addChatMessage(DBMessage dBMessage) async {
    final db = await myDataBase;

    await db.insert(
      _tableName,
      dBMessage.toMap(),
    );
  }

  Future<void> removeChatMessage(int messageId) async {
    final db = await myDataBase;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [messageId],
    );
  }

  Future<List<DBMessage>> getAllMessagesForCharacter(String characterId) async {
    final db = await myDataBase;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'character_id = ?',
      whereArgs: [characterId],
    );
    return List.generate(maps.length, (i) {
      return DBMessage.fromMap(maps[i]);
    });
  }
}
