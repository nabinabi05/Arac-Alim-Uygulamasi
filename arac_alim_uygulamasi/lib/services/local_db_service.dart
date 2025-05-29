// lib/services/db_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/car.dart';
import '../models/order.dart';

class DBHelper {
  static Database? _db;

  /// Veritabanı örneğini döner (singleton)
  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  /// Veritabanını açar / oluşturur
  static Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_data.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      // İleride versiyon arttığında migration için onUpgrade ekleyebilirsin
    );
  }

  /// İlk seferde tablo yapısını kurar
  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id    INTEGER PRIMARY KEY AUTOINCREMENT,
        name  TEXT,
        email TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE cars(
        id     INTEGER PRIMARY KEY AUTOINCREMENT,
        brand  TEXT,
        model  TEXT,
        price  REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE orders(
        id      INTEGER PRIMARY KEY AUTOINCREMENT,
        userId  INTEGER,
        carId   INTEGER,
        date    TEXT,
        FOREIGN KEY(userId) REFERENCES users(id),
        FOREIGN KEY(carId)  REFERENCES cars(id)
      )
    ''');
  }

  // ─── USER CRUD ──────────────────────────────────────────────────────────────

  static Future<int> insertUser(User u) async {
    final dbClient = await db;
    return dbClient.insert('users', u.toMap());
  }

  static Future<List<User>> getUsers() async {
    final dbClient = await db;
    final rows = await dbClient.query('users');
    return rows.map((r) => User.fromMap(r)).toList();
  }

  static Future<int> updateUser(User u) async {
    final dbClient = await db;
    return dbClient.update(
      'users',
      u.toMap(),
      where: 'id = ?',
      whereArgs: [u.id],
    );
  }

  static Future<int> deleteUser(int id) async {
    final dbClient = await db;
    return dbClient.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // ─── CAR CRUD ────────────────────────────────────────────────────────────────

  static Future<int> insertCar(Car c) async {
    final dbClient = await db;
    return dbClient.insert('cars', c.toMap());
  }

  static Future<List<Car>> getCars() async {
    final dbClient = await db;
    final rows = await dbClient.query('cars');
    return rows.map((r) => Car.fromMap(r)).toList();
  }

  static Future<int> updateCar(Car c) async {
    final dbClient = await db;
    return dbClient.update(
      'cars',
      c.toMap(),
      where: 'id = ?',
      whereArgs: [c.id],
    );
  }

  static Future<int> deleteCar(int id) async {
    final dbClient = await db;
    return dbClient.delete('cars', where: 'id = ?', whereArgs: [id]);
  }

  // ─── ORDER CRUD ──────────────────────────────────────────────────────────────

  static Future<int> insertOrder(Order o) async {
    final dbClient = await db;
    return dbClient.insert('orders', o.toMap());
  }

  static Future<List<Order>> getOrders() async {
    final dbClient = await db;
    final rows = await dbClient.query('orders');
    return rows.map((r) => Order.fromMap(r)).toList();
  }

  static Future<int> updateOrder(Order o) async {
    final dbClient = await db;
    return dbClient.update(
      'orders',
      o.toMap(),
      where: 'id = ?',
      whereArgs: [o.id],
    );
  }

  static Future<int> deleteOrder(int id) async {
    final dbClient = await db;
    return dbClient.delete('orders', where: 'id = ?', whereArgs: [id]);
  }
}
