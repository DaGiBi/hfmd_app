import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStoringUtillities {
  static Future<void> storeLocally(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedFile = data;

      final directory = await getApplicationDocumentsDirectory();
      final fileName = DateTime.now().toString() + '.json';
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(jsonEncode(storedFile));

      await prefs.setString('stored_file', fileName);

      print('Data stored locally successfully');
    } catch (e) {
      print('Error storing data locally: $e');
    }
  }

  static Future<Map<String, dynamic>> loadFileData(String fileName) async {
    try {
      final file = File(fileName);
      final jsonData = await file.readAsString();
      final data = jsonDecode(jsonData);
      return data;
    } catch (e) {
      print('Error loading file data: $e');
      return {};
    }
  }
}