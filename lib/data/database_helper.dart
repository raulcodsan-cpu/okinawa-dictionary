import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initPrepopulatedDB('okinawan_dictionary.db');
    return _database!;
  }

  Future<Database> _initPrepopulatedDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Check if the database already exists in the device's local storage
    final exists = await databaseExists(path);

    if (!exists) {
      // If it doesn't exist, copy it from the assets folder
      print("Creating a copy of the pre-populated database from assets...");

      try {
        // Ensure the parent directory exists
        await Directory(dirname(path)).create(recursive: true);

        // Load database file from assets as byte data
        ByteData data = await rootBundle.load(join('assets', filePath));
        List<int> bytes = data.buffer.asUint8List(
          data.offsetInBytes,
          data.lengthInBytes,
        );

        // Write the byte data into the local storage file system
        await File(path).writeAsBytes(bytes, flush: true);
        print("Database successfully copied.");
      } catch (e) {
        print("Error copying database from assets: $e");
      }
    } else {
      print("Database already exists on device. Opening existing database...");
    }

    // Open the newly copied database
    return await openDatabase(path);
  }

  // SEARCH METHOD (same as before)
  Future<List<Map<String, dynamic>>> searchWords(String query) async {
    final db = await instance.database;
    return await db.query(
      'dictionary',
      where: 'okinawan LIKE ? OR japanese LIKE ? OR tags LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );
  }
}
