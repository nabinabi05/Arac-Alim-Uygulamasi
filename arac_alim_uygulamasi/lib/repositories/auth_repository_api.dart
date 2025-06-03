// lib/repositories/auth_repository_api.dart

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert'; // <-- eklendi
import '../constants.dart';
import 'iauth.dart';

class AuthRepositoryApi implements IAuthRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  AuthRepositoryApi(this._dio) : _storage = const FlutterSecureStorage();

  @override
  Future<void> login(String email, String password) async {
    print(">>> AuthRepositoryApi.login()");
    print("    baseUrl: ${_dio.options.baseUrl}");
    print("    POST to: ${_dio.options.baseUrl}/token/");
    print("    body: { username: \"$email\", password: \"$password\" }");

    final res = await _dio.post('/token/', data: {
      'username': email,
      'password': password,
    });

    print("<<< AuthRepositoryApi.login() RESPONSE [${res.statusCode}] → ${res.data}");

    final token = res.data['access'] as String;
    await _storage.write(key: 'jwt', value: token);
    print("    Stored JWT = $token");
  }

  @override
  Future<void> register(String email, String password) async {
    print(">>> AuthRepositoryApi.register()");
    print("    baseUrl: ${_dio.options.baseUrl}");
    print("    POST to: ${_dio.options.baseUrl}/users/");
    print("    body: { username: \"$email\", password: \"$password\" }");

    final res = await _dio.post('/users/', data: {
      'username': email,
      'password': password,
    });

    print("<<< AuthRepositoryApi.register() RESPONSE [${res.statusCode}] → ${res.data}");

    // Başarılı register’dan sonra otomatik login yapıyoruz
    await login(email, password);
  }

  @override
  Future<void> logout() async {
    print(">>> AuthRepositoryApi.logout()");
    await _storage.delete(key: 'jwt');
    print("    JWT removed");
  }

  /// Yeni eklenen getter: Saklanan JWT’yi decode ederek içindeki `user_id` alanını döner.
  Future<int?> getCurrentUserId() async {
    // 1) Secure storage’dan token’ı oku
    final token = await _storage.read(key: 'jwt');
    if (token == null) return null;

    try {
      // 2) JWT üç parçaya ayrılır: header.payload.signature
      final parts = token.split('.');
      if (parts.length != 3) return null;

      // 3) payload kısmını base64-url decode et
      var payload = parts[1];
      // Base64 padding kontrolü (base64Url.normalize kullanabiliriz)
      payload = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(payload));

      // 4) JSON parse ederek içinden user_id’yi al
      final payloadMap = json.decode(decoded) as Map<String, dynamic>;
      final id = payloadMap['user_id'] as int?;
      return id;
    } catch (e) {
      print("Error decoding JWT to get user_id: $e");
      return null;
    }
  }
}
