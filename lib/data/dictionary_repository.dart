import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uchinaguchi_jisho/models/word_item.dart';

class DictionaryRepository {
  static Database? _database;

  @visibleForTesting
  static set mockDatabase(Database? mockDb) {
    _database = mockDb;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initPrepopulatedDB('okinawa_pandas.db');
    return _database!;
  }

  Future<Database> _initPrepopulatedDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    final exists = await databaseExists(path);

    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
        ByteData data = await rootBundle.load(join('assets', filePath));
        List<int> bytes = data.buffer.asUint8List(
          data.offsetInBytes,
          data.lengthInBytes,
        );
        await File(path).writeAsBytes(bytes, flush: true);
      } catch (e) {
        debugPrint('Error copying database: $e');
      }
    }
    return await openDatabase(path);
  }

  // Fetch surrounding words by ID
  Future<List<WordItem>> searchFromId(int wordId) async {
    final db = await database;
    final result = await db.query(
      'dictionary',
      where: 'id IN (?, ?, ?)',
      whereArgs: [wordId - 1, wordId, wordId + 1],
    );

    return result.map((element) {
      final kana = element['kana'].toString().replaceAll(
        RegExp(r"[\[\]']"),
        '',
      );
      final List<String> loadedMeanings = [];

      for (var i = 1; i <= 3; i++) {
        if (element['meaning$i'] != null) {
          loadedMeanings.add(element['meaning$i'].toString());
        }
      }

      return WordItem(
        id: element['id'] as int,
        word: element['word'] as String,
        ipa: (element['ipa'] ?? '') as String,
        kana: kana,
        meanings: loadedMeanings,
      );
    }).toList();
  }

  // Search by query string
  Future<List<WordItem>> searchWords(String query) async {
    final db = await database;
    final loadedItems = await db.query(
      'dictionary',
      where: 'word LIKE ? OR kana LIKE ? OR meaning1 LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );

    return loadedItems.map((element) {
      final kana = element['kana'].toString().replaceAll(
        RegExp(r"[\[\]']"),
        '',
      );
      final List<String> loadedMeanings = [];
      for (var i = 1; i <= 3; i++) {
        if (element['meaning$i'] != null) {
          loadedMeanings.add(element['meaning$i'].toString());
        }
      }
      return WordItem(
        id: element['id'] as int,
        word: element['word'] as String,
        ipa: (element['ipa'] ?? '') as String,
        kana: kana,
        meanings: loadedMeanings,
      );
    }).toList();
  }
}
