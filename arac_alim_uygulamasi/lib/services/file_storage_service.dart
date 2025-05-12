import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileStorageService {
  static const String _fileName = "settings.json";

  static Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return "${directory.path}/$_fileName";
  }

  static Future<void> writeData(Map<String, dynamic> data) async {
    final path = await _getFilePath();
    final file = File(path);
    final jsonData = jsonEncode(data);
    await file.writeAsString(jsonData);
  }

  static Future<Map<String, dynamic>?> readData() async {
    try {
      final path = await _getFilePath();
      final file = File(path);

      if (!await file.exists()) return null;

      final jsonData = await file.readAsString();
      return jsonDecode(jsonData);
    } catch (e) {
      print("Dosya okuma hatası: $e");
      return null;
    }
  }
}
