import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/car.dart';

class LocalDbService {
  static final LocalDbService _instance = LocalDbService._();
  Database? _db;

  LocalDbService._();
  factory LocalDbService() => _instance;

  Future<Database> get database async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'arac_alim_offline.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // cars table
        await db.execute('''
          CREATE TABLE cars (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            make TEXT,
            model TEXT,
            year INTEGER
          )
        ''');

        // users table
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');

        // session table (single‐row)
        await db.execute('''
          CREATE TABLE session (
            id INTEGER PRIMARY KEY CHECK (id = 1),
            user_id INTEGER
          )
        ''');
      },
    );
    return _db!;
  }

  // --- Car methods ---
  Future<void> insertCar(Car car) async {
    final db = await database;
    await db.insert('cars', car.toMap());
  }
  Future<List<Car>> getAllCars() async {
    final db = await database;
    final rows = await db.query('cars');
    return rows.map((r) => Car.fromMap(r)).toList();
  }

  // --- User methods ---
  Future<int> createUser(String email, String password) async {
    final db = await database;
    return db.insert('users', {'email': email, 'password': password});
  }
  Future<Map<String, dynamic>?> getUser(String email) async {
    final db = await database;
    final rows = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return rows.isNotEmpty ? rows.first : null;
  }

  // --- Session (simple) ---
  Future<void> saveSession(int userId) async {
    final db = await database;
    await db.delete('session');
    await db.insert('session', {'id': 1, 'user_id': userId});
  }
  Future<int?> getSession() async {
    final db = await database;
    final rows = await db.query('session');
    return rows.isNotEmpty ? rows.first['user_id'] as int : null;
  }
  Future<void> clearSession() async {
    final db = await database;
    await db.delete('session');
  }
}
