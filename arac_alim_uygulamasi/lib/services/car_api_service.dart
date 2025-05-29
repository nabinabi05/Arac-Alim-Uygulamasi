// File: lib/services/car_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/car.dart';
import 'auth_service.dart';

class CarApiService {
  static const String baseUrl = "https://your-api-url.com/api/cars/";

  /// Araç listesini Car modeline dönüştürüp döndürür
  static Future<List<Car>> getCars() async {
    final token = await AuthService.getToken();
    final resp = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    if (resp.statusCode == 200) {
      final List data = jsonDecode(resp.body);
      return data
          .map((e) => Car.fromMap(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception("Araçlar alınamadı: ${resp.statusCode}");
  }

  // addCar, updateCar, deleteCar… aynı şekilde header ekleyin
}
