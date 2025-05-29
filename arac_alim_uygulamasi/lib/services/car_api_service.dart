import 'local_db_service.dart';
import '../models/car.dart';

class CarApiService {
  final _db = LocalDbService();

  /// Tüm araçları getir
  Future<List<Car>> getCars() async {
    return _db.getAllCars();
  }

  /// Tek bir aracı getir
  Future<Car?> getCar(int id) async {
    return _db.getCarById(id);
  }

  /// Yeni araç oluştur
  Future<bool> createCar(Car car) async {
    final newId = await _db.insertCar(car);
    return newId > 0;
  }

  /// Mevcut aracı güncelle
  Future<bool> updateCar(Car car) async {
    final count = await _db.updateCar(car);
    return count > 0;
  }

  /// Aracı sil
  Future<bool> deleteCar(int id) async {
    final count = await _db.deleteCar(id);
    return count > 0;
  }
}
