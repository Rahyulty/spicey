import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

class MyDatabase {
  final String _directoryPath;

  MyDatabase(String directoryPath) : _directoryPath = directoryPath;

  Future<Map<String, dynamic>> getTable(String tableName) async {
    final file = File(path.join(_directoryPath, '$tableName.json'));
    if (!file.existsSync()) {
      return {};
    }

    final contents = await file.readAsString();
    return json.decode(contents);
  }

  Future<void> setTable(String tableName, Map<String, dynamic> data) async {
    final file = File(path.join(_directoryPath, '$tableName.json'));
    await file.writeAsString('');
    await file.writeAsString(json.encode(data));
  }
}
