// File: lib/services/storage_service.dart

import 'package:shared_preferences/shared_preferences.dart';

/// Basit anahtar-değer tercihler (tema, dil, son giriş email’i) için servis.
class StorageService {
  static const _keyThemeMode = 'theme_mode';
  static const _keyLocale = 'locale';
  static const _keyLastLoginEmail = 'last_login_email';

  /// Tema bilgisini saklar ('light' veya 'dark').
  Future<void> setThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemeMode, mode);
  }

  /// Saklı tema bilgisini döner, yoksa null.
  Future<String?> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyThemeMode);
  }

  /// Dil tercihini saklar (örneğin 'en', 'tr').
  Future<void> setLocale(String locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLocale, locale);
  }

  /// Saklı dil tercihini döner, yoksa null.
  Future<String?> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLocale);
  }

  /// Son başarılı giriş yapan kullanıcının email’ini saklar.
  Future<void> setLastLoginEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastLoginEmail, email);
  }

  /// Saklı son giriş email’ini döner, yoksa null.
  Future<String?> getLastLoginEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastLoginEmail);
  }

  /// Tüm saklamaları temizler (örneğin, logout sırasında).
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyThemeMode);
    await prefs.remove(_keyLocale);
    await prefs.remove(_keyLastLoginEmail);
  }
}
