import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String baseUrl = "https://your-api-url.com/api";
  static const _storage = FlutterSecureStorage();

  // Login işlemi
  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/token/"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.write(key: 'access', value: data['access']);
      await _storage.write(key: 'refresh', value: data['refresh']);
      return true;
    } else {
      return false;
    }
  }

  // Logout işlemi
  static Future<void> logout() async {
    await _storage.deleteAll();
  }

  // Token alma
  static Future<String?> getToken() async {
    return await _storage.read(key: 'access');
  }

  // Giriş yapmış mı kontrolü
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}
