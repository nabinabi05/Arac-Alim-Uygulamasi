// lib/providers/language_notifier.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Bu provider, uygulamanın genel dil (locale) bilgisini tutacak.
final languageNotifierProvider =
    StateNotifierProvider<LanguageNotifier, Locale>((ref) {
  return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<Locale> {
  static const _prefKey = 'languageCode';

  /// Desteklenen dillerinizi burada listeleyin:
  /// Örneğin: Türkçe ve İngilizce
  static const supportedLocales = [
    Locale('en'),
    Locale('tr'),
  ];

  LanguageNotifier() : super(const Locale('tr')) {
    _loadLanguageFromPrefs();
  }

  Future<void> _loadLanguageFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefKey) ?? 'tr';
    state = Locale(code);
  }

  /// Yeni bir dil seçimi yap ve SharedPreferences'a kaydet.
  Future<void> setLanguage(String languageCode) async {
    // Eğer desteklenenler arasında değilse, varsayılan dil kalır
    final locale = supportedLocales.firstWhere(
      (l) => l.languageCode == languageCode,
      orElse: () => const Locale('tr'),
    );
    state = locale;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, languageCode);
  }
}
