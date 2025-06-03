// lib/repositories/car_repository_api.dart

import 'package:dio/dio.dart';
import '../models/car.dart';
import 'icars.dart';

class CarRepositoryApi implements ICarRepository {
  final Dio _dio;

  /// We inject a shared Dio (with baseUrl = http://10.0.2.2:8000/api and jwtInterceptor)
  CarRepositoryApi(this._dio);

  /// The original “fetchAll” method (no change)
  @override
  Future<List<Car>> fetchAll({Map<String, dynamic>? filters}) async {
    final res = await _dio.get('/cars/', queryParameters: filters);
    return (res.data as List)
        .map((e) => Car.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// The original “fetchById” method (no change)
  @override
  Future<Car> fetchById(String id) async {
    final res = await _dio.get('/cars/$id/');
    return Car.fromJson(res.data as Map<String, dynamic>);
  }

  /// The original “create” (by passing a Car instance)
  @override
  Future<Car> create(Car car) async {
    final res = await _dio.post('/cars/', data: car.toJson());
    return Car.fromJson(res.data as Map<String, dynamic>);
  }

  /// New “createCar” method for the UI’s named‐parameter call.
  /// This sends exactly the JSON your backend expects (brand, model_name, year, price,
  /// description, latitude, longitude), then parses the response into a Car.
  Future<Car> createCar({
    required String brand,
    required String modelName,
    required int year,
    required double price,
    required String description,
    required double latitude,
    required double longitude,
  }) async {
    final res = await _dio.post('/cars/', data: {
      'brand': brand,
      'model_name': modelName,
      'year': year,
      'price': price,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
    });
    return Car.fromJson(res.data as Map<String, dynamic>);
  }

  /// The original “update” method (no change)
  @override
  Future<void> update(String id, Car car) async {
    await _dio.put('/cars/$id/', data: car.toJson());
  }

  /// The original “delete” method (no change)
  @override
  Future<void> delete(String id) async {
    await _dio.delete('/cars/$id/');
  }
}
