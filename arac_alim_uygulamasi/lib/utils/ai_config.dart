// lib/utils/ai_config.dart

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// `.env` dosyasından okunacak OpenRouter API anahtarı.
/// Proje kökünde şu satırı içeren bir `.env` dosyası olmalı:
///   OPENROUTER_API_KEY=sk-or-v1-…
String get openrouterApiKey => dotenv.env['OPENROUTER_API_KEY'] ?? '';
