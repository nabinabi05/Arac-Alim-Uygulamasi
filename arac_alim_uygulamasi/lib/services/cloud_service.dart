// File: lib/services/cloud_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class CloudService {
  /// Your deployed ML model’s REST endpoint
  static const _endpoint = 'https://YOUR_CLOUD_API_URL/predict';

  /// Sends [carData] (brand, modelName, year, price, description, etc.)
  /// to the cloud API and returns the predicted price.
  static Future<double> getPredictedPrice(Map<String, dynamic> carData) async {
    final uri = Uri.parse(_endpoint);
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(carData),
    );

    if (response.statusCode == 200) {
      // Expecting JSON like: { "predicted_price": 12345.67 }
      final Map<String, dynamic> json = jsonDecode(response.body);
      if (json.containsKey('predicted_price')) {
        return (json['predicted_price'] as num).toDouble();
      } else {
        throw Exception('Missing "predicted_price" in response: ${response.body}');
      }
    } else {
      throw Exception(
        'Prediction API error: ${response.statusCode} ${response.reasonPhrase}',
      );
    }
  }
}
