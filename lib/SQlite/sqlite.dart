import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../JsonModels/users.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'users.db');

    // open the database
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE User (
        usrId INTEGER PRIMARY KEY AUTOINCREMENT,
        usremail TEXT,
        userPassword TEXT
      )
    ''');
  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res = await dbClient!.insert('User', user.toMap());
    return res;
  }

  Future<User?> getUser(String email) async {
    var dbClient = await db;
    List<Map<String, dynamic>> result = await dbClient!.query('User', where: 'usremail = ?', whereArgs: [email]);
    if (result.isEmpty) return null;
    return User.fromMap(result.first);
  }
}
