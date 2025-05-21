// lib/services/cloud_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudRepository {
  final String _baseUrl = dotenv.env['CLOUD_API_URL']!;

  /// Car verisini JSON’a çevirip tahmin isteği atar.
  Future<int?> predictPrice(Map<String, dynamic> carData) async {
    final uri = Uri.parse(_baseUrl);
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (dotenv.env['API_KEY'] != null) 'Authorization': 'Bearer ${dotenv.env['API_KEY']}',
      },
      body: jsonEncode(carData),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['predicted_price'] as int?;
    } else {
      throw Exception('Tahmin API hatası: ${response.statusCode}');
    }
  }
}
