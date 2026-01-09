import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class JsonHelper {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.json');
  }

  static Future<Map<String, dynamic>> readJsonData() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        return json.decode(contents) as Map<String, dynamic>;
      }
    } catch (e) {
      // Fall through to load from assets
    }

    final assetData = await rootBundle.loadString('assets/data.json');
    return json.decode(assetData) as Map<String, dynamic>;
  }

  static Future<File> writeJsonData(List<dynamic> data) async {
    final file = await _localFile;
    final jsonString = json.encode({'semesters': data});
    return file.writeAsString(jsonString);
  }
}
