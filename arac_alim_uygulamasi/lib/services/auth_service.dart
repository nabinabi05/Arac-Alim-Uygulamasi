// File: lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String baseUrl = "https://your-api-url.com/api";
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'access';

  /// Login işlemi: access token saklanır
  static Future<bool> login(String email, String password) async {
    final resp = await http.post(
      Uri.parse("$baseUrl/token/"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      await _storage.write(key: _tokenKey, value: data['access']);
      return true;
    }
    return false;
  }

  /// Kayıt
  static Future<bool> register(String email, String password) async {
    final resp = await http.post(
      Uri.parse("$baseUrl/register/"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return resp.statusCode == 201;
  }

  /// Mevcut token’ı okur
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Logout: tüm anahtarları siler
  static Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
  }
}
