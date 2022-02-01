import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseFileRoutines {
  final String database;

  DatabaseFileRoutines({required this.database});

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    return File('$path/${database}_db.json');
  }

  Future<String> readDatabase() async {
    try {
      final file = await _localFile;

      if (!file.existsSync()) {
        print("File does not Exist: ${file.absolute}");
        file.create();
        await writeDatabase('{"$database": []}');
      }

      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      print("error readDatabase: $e");
      return "";
    }
  }

  Future<File> writeDatabase(String json) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(json);
  }
}
