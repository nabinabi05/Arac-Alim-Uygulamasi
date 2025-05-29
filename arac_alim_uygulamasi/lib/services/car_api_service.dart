// lib/services/car_api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../models/car.dart';

class CarApiService {
  static const _baseUrl = 'http://10.0.2.2:8000/api/cars/';

  static Future<List<Car>> getCars() async {
    final token = await AuthService.getToken();
    print('▶ CarApiService.getCars() token=$token');
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    print('   └─ GET $_baseUrl  headers=$headers');

    final resp = await http.get(Uri.parse(_baseUrl), headers: headers);
    print('◀ CarApiService.getCars ← status=${resp.statusCode}, body=${resp.body}');
    if (resp.statusCode == 200) {
      final list = jsonDecode(resp.body) as List;
      print('   └─ parsed ${list.length} cars');
      return list.map((e) => Car.fromMap(e)).toList();
    } else {
      throw Exception('Fetch cars failed: ${resp.statusCode}');
    }
  }

  static Future<void> addCar(Car car) async {
    final token = await AuthService.getToken();
    print('▶ CarApiService.addCar() token=$token, car=${car.toMap()}');
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    print('   └─ POST $_baseUrl  headers=$headers');

    final resp = await http.post(
      Uri.parse(_baseUrl),
      headers: headers,
      body: jsonEncode(car.toMap()),
    );
    print('◀ CarApiService.addCar ← status=${resp.statusCode}, body=${resp.body}');
    if (resp.statusCode != 201) {
      throw Exception('Add car failed: ${resp.statusCode}');
    }
  }
}
