// lib/utils/ai_service.dart

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/ai_config.dart';

class AiService {
  final Dio _dio = Dio();

  AiService() {
    // Eğer main.dart içinde dotenv.load() çağrılmadıysa burada da tetiklenebilir:
    if (dotenv.env.isEmpty) {
      dotenv.load();
    }
  }

  /// Araç bilgilerine göre tahmini fiyat alır.
  /// OpenRouter API üzerinden chat tamamlaması isteği yapar.
  Future<double> predictPrice({
    required String brand,
    required String modelName,
    required int year,
    required String description,
  }) async {
    // 1) Prompt’u oluşturuyoruz
    final prompt = """
You are a car pricing expert.
Given the following car details, propose a single numeric price in Turkish Lira (₺), e.g. 350000.00:

Brand: $brand
Model: $modelName
Year: $year
Description: $description

Just return the estimated price as a number (e.g. 350000.00) with no other text.
""";

    final apiKey = openrouterApiKey;
    if (apiKey.isEmpty) {
      throw Exception("OPENROUTER_API_KEY bulunamadı!");
    }

    // 2) İstek gövdesini hazırla
    final body = {
      "model": "deepseek/deepseek-r1-0528-qwen3-8b:free",
      "messages": [
        {
          "role": "user",
          "content": prompt,
        }
      ],
      "stream": false
    };

    // 3) İstek başlıkları
    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    try {
      // 4) POST isteğini yap
      final response = await _dio.post(
        "https://openrouter.ai/api/v1/chat/completions",
        data: jsonEncode(body),
        options: Options(headers: headers),
      );

      // 5) JSON’dan 'choices[0].message.content' alanını al
      final data = response.data;
      if (data == null ||
          data['choices'] == null ||
          data['choices'].isEmpty ||
          data['choices'][0]['message'] == null ||
          data['choices'][0]['message']['content'] == null) {
        throw Exception("Beklenmeyen API cevabı yapısı.");
      }

      final content = data['choices'][0]['message']['content'] as String;

      // 6) İçerikteki sayısal kısmı regex ile ayıkla
      final regex = RegExp(r"[\d]+(?:[.,]\d+)?");
      final match = regex.firstMatch(content);
      if (match != null) {
        final raw = match.group(0)!.replaceAll(',', '.');
        return double.tryParse(raw) ?? 0.0;
      }

      // Eğer sayı bulunamadıysa 0.0 döner
      return 0.0;
    } on DioError {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
