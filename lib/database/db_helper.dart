import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('diary.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // 데이터베이스 버전 업데이트
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE diary_entries (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER NOT NULL,
      emotion TEXT NOT NULL,
      content TEXT NOT NULL,
      date TEXT NOT NULL,
      imagePath TEXT -- 이미지 경로 추가
    )
  ''');

    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      phone TEXT NOT NULL UNIQUE
    )
  ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE diary_entries ADD COLUMN imagePath TEXT');
      print('Database upgraded to version: $newVersion');
    }
  }

  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'diary.db');
    await deleteDatabase(path);
    print('Database file deleted');
  }

  Future<void> deleteDiaryEntry(int id) async {
    final db = await instance.database;
    await db.delete(
      'diary_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
