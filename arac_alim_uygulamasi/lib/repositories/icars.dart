/// lib/repositories/icars.dart

import '../models/car.dart';

abstract class ICarRepository {
  Future<List<Car>> fetchAll({Map<String, dynamic>? filters});
  Future<Car> fetchById(String id);
  Future<Car> create(Car car);
  Future<void> update(String id, Car car);
  Future<void> delete(String id);
}
