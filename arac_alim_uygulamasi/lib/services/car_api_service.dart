import 'dart:convert';
import 'package:http/http.dart' as http;

class CarApiService {
  static const String baseUrl = "https://your-api.com/api/cars/";

  // Araçları listele (GET)
  static Future<List<dynamic>> getCars() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Araçlar alınamadı.");
    }
  }

  // Yeni araç ekle (POST)
  static Future<bool> addCar(Map<String, dynamic> carData) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(carData),
    );
    return response.statusCode == 201;
  }

  // Araç güncelle (PUT)
  static Future<bool> updateCar(int id, Map<String, dynamic> carData) async {
    final response = await http.put(
      Uri.parse("$baseUrl$id/"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(carData),
    );
    return response.statusCode == 200;
  }

  // Araç sil (DELETE)
  static Future<bool> deleteCar(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl$id/"));
    return response.statusCode == 204;
  }
}
