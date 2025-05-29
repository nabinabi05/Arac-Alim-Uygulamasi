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
    final path = join(dbPath, 'arac_alim.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE cars (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            brand TEXT,
            modelName TEXT,
            year INTEGER,
            price REAL,
            description TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');
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

  // Car CRUD
  Future<int> insertCar(Car car) async {
    final db = await database;
    return db.insert('cars', car.toMap());
  }

  Future<List<Car>> getAllCars() async {
    final db = await database;
    final rows = await db.query('cars');
    return rows.map((r) => Car.fromMap(r)).toList();
  }

  Future<int> updateCar(Car car) async {
    final db = await database;
    return db.update(
      'cars',
      car.toMap(),
      where: 'id = ?',
      whereArgs: [car.id],
    );
  }

  Future<int> deleteCar(int id) async {
    final db = await database;
    return db.delete('cars', where: 'id = ?', whereArgs: [id]);
  }

  Future<Car?> getCarById(int id) async {
    final db = await database;
    final rows = await db.query(
      'cars',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (rows.isEmpty) return null;
    return Car.fromMap(rows.first);
  }

  // User / Session
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
