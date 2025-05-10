import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // Tema bilgisini kaydeder (true: Koyu Tema, false: Açık Tema)
  static Future<void> saveTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  // Tema bilgisini okur. Kayıt yoksa varsayılan false döner.
  static Future<bool> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDarkMode') ?? false;
  }

  // Dil bilgisini kaydeder (örn: 'tr', 'en')
  static Future<void> saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
  }

  // Dil bilgisini okur. Kayıt yoksa varsayılan 'tr' döner.
  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('languageCode') ?? 'tr';
  }
}
