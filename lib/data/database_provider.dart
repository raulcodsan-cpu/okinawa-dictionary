import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider extends StateNotifier<List<Map<String, dynamic>>> {
  DatabaseProvider() : super(const []);

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initPrepopulatedDB('okinawa_pandas.db');
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

  // Search
  Future<List<Map<String, dynamic>>> searchWords(String query) async {
    final db = await database;
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'",
    );
    tables.forEach((table) => print(table['name']));

    return await db.query(
      'dictionary',
      where: 'word LIKE ? OR kana LIKE ? OR meaning1 LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );
  }
}

final databaseProvider =
    StateNotifierProvider<DatabaseProvider, List<Map<String, dynamic>>>(
      (ref) => DatabaseProvider(),
    );
