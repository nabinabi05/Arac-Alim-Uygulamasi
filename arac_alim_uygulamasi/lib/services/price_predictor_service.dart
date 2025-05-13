import 'dart:convert';
import 'package:http/http.dart' as http;

class PricePredictorService {
  // AI tahmin servisine istek yapılacak endpoint (örnek URL)
  static const String baseUrl = "https://your-ai-server.com/api/predict-price/";

  static Future<int?> getPredictedPrice(Map<String, dynamic> carData) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(carData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['predicted_price']; // JSON'dan fiyatı çekiyoruz
      } else {
        print("Tahmin alınamadı: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Hata oluştu: $e");
      return null;
    }
  }
}
