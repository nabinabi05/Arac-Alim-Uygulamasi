// lib/services/car_repository.dart
import '../models/car.dart';
import 'car_api_service.dart';

class CarRepository {
  /// Tüm araçları çekip Car modeline dönüştürür.
  Future<List<Car>> fetchCars() async {
    final data = await CarApiService.getCars();
    return data.map((m) => Car.fromMap(m as Map<String, dynamic>)).toList();
  }

  /// Yeni bir araç ekler.
  Future<bool> addCar(Car car) async {
    return await CarApiService.addCar(car.toMap());
  }

  /// Mevcut bir aracı günceller.
  Future<bool> updateCar(Car car) async {
    if (car.id == null) throw Exception("Car id null");
    return await CarApiService.updateCar(car.id!, car.toMap());
  }

  /// ID’ye göre araç siler.
  Future<bool> deleteCar(int id) async {
    return await CarApiService.deleteCar(id);
  }
}
