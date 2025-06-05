// lib/providers/theme_notifier.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Bu provider, uygulamanın genel tema (light/dark) bilgisini tutacak.
final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  static const _prefKey = 'isDarkMode';

  ThemeNotifier() : super(ThemeMode.light) {
    _loadFromPrefs();
  }

  /// SharedPreferences'tan 'isDarkMode' anahtarını çek ve state'i güncelle.
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_prefKey) ?? false;
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  /// Tema tercihini değiştir ve SharedPreferences'a kaydet.
  Future<void> toggleTheme() async {
    final newTheme = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    state = newTheme;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, newTheme == ThemeMode.dark);
  }
}
