import '../models/car.dart';
import 'local_db_service.dart';

class CarRepository {
  final _db = LocalDbService();

  Future<List<Car>> getCars() => _db.getAllCars();

  Future<bool> addCar(Car car) async {
    try {
      await _db.insertCar(car);
      return true;
    } catch (_) {
      return false;
    }
  }
}
