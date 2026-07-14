import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uchinaguchi_jisho/data/selected_word_provider.dart';
import 'package:uchinaguchi_jisho/models/word_item.dart';

class DatabaseNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  DatabaseNotifier(this._ref) : super(const []);
  final Ref _ref;

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
      print('Creating a copy of the pre-populated database from assets...');

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
        print('Database successfully copied.');
      } catch (e) {
        print('Error copying database from assets: $e');
      }
    } else {
      print('Database already exists on device. Opening existing database...');
    }

    // Open the newly copied database
    return await openDatabase(path);
  }

  // Search
  Future<List<WordItem>> searchWords(String query) async {
    final db = await database;

    /*     ---- SQL table debug code ---- 
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'",
    );
      for (var table in tables) {
      print(table['name']);
    } */

    final loadedItems = await (db.query(
      'dictionary',
      where: 'word LIKE ? OR kana LIKE ? OR meaning1 LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    ));

    final List<WordItem> loadedWords = [];
    for (var element in loadedItems) {
      final List<String> loadedMeanings = [];
      final kana = element['kana'].toString().replaceAll(
        RegExp(r"[\[\]']"),
        '',
      );
      //Convert meanings to a List to use later for ListBuilder.
      for (var i = 1; i <= 3; i++) {
        if (element['meaning$i'] == null) {
          continue;
        }
        loadedMeanings.add(element['meaning$i'].toString());
      }

      loadedWords.add(
        WordItem(
          id: element['id'] as int,
          word: element['word'] as String,
          ipa: element['ipa'] == null ? '' : element['ipa'] as String,
          kana: kana,
          meanings: loadedMeanings,
        ),
      );
    }
    return loadedWords;
  }

  //Search adjacent words (for entry_screen)
  Future<List<WordItem>> searchAdjacent(int wordId) async {
    final db = await database;

    //TODO: Handle case first and last word.
    //TODO: Comment on the function.

    final result = await db.query(
      'dictionary',
      where: 'id IN (?, ?)',
      whereArgs: [wordId + 1, wordId - 1],
    );

    final List<WordItem> loadedWords = [];
    for (var element in result) {
      final List<String> loadedMeanings = [];
      final kana = element['kana'].toString().replaceAll(
        RegExp(r"[\[\]']"),
        '',
      );
      //Convert meanings to a List to use later for ListBuilder.
      for (var i = 1; i <= 3; i++) {
        if (element['meaning$i'] == null) {
          continue;
        }
        loadedMeanings.add(element['meaning$i'].toString());
      }

      loadedWords.add(
        WordItem(
          id: element['id'] as int,
          word: element['word'] as String,
          ipa: element['ipa'] == null ? '' : element['ipa'] as String,
          kana: kana,
          meanings: loadedMeanings,
        ),
      );
    }

    return loadedWords;
  }

  Future<WordItem> searchFromId(int wordId) async {
    final db = await database;

    //TODO: Handle case first and last word.

    final result = await db.query(
      'dictionary',
      where: 'id IN (?)',
      whereArgs: [wordId],
    );

    final String kana = result[0]['kana'].toString().replaceAll(
      RegExp(r"[\[\]']"),
      '',
    );
    final List<String> loadedMeanings = [];
    for (var i = 1; i <= 3; i++) {
      if (result[0]['meaning$i'] == null) {
        continue;
      }
      loadedMeanings.add(result[0]['meaning$i'].toString());
    }
    final WordItem loadedWord;
    loadedWord = WordItem(
      id: result[0]['id'] as int,
      word: result[0]['word'] as String,
      ipa: result[0]['ipa'] == null ? '' : result[0]['ipa'] as String,
      kana: kana,
      meanings: loadedMeanings,
    );

    _ref.read(selectedWordProvider.notifier).select(loadedWord);
    return loadedWord;
  }

  /* 
  void addFavouriteWord() async {
    final db = await database;
    final word = _ref.read(selectedWordProvider);

    await db.execute('''
        CREATE TABLE IF NOT EXISTS favourites (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          word_id INTEGER UNIQUE
        )
      ''');

    try {
      db.execute('INSERT OR IGNORE INTO favourites (word_id) VALUES (?)', [
        word!.id,
      ]);
    } catch (e) {
      print('Error while adding word: $e');
      return;
    }
    print('Word added correctly');
  }

  void removeFavWord() async {
    final db = await database;
    final word = _ref.read(selectedWordProvider);

    await db.execute('''
        CREATE TABLE IF NOT EXISTS favourites (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          word_id INTEGER UNIQUE
        )
      ''');

    try {
      //---------------- TODO: Take note (execute word.id arg) ----------------------
      db.execute('DELETE FROM favourites WHERE word_id = ?', [word!.id]);
    } catch (e) {
      print('Error while deleting word: $e');
    }
    print('Word deleted correctly');
  }

  //Func. for bookmark icon change.
  Future<bool> isFavourite(WordItem word) async {
    final db = await database;

    await db.execute('''
        CREATE TABLE IF NOT EXISTS favourites (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          word_id INTEGER UNIQUE
        )
      ''');

    final result = await db.rawQuery(
      'SELECT 1 FROM favourites WHERE word_id = ? LIMIT 1',
      [word.id],
    );

    return result.isNotEmpty;
  }

  Future<List<WordItem>> getFavouriteWords() async {
    final db = await database;
    final results = await db.rawQuery('''
      SELECT dictionary.* FROM favourites
      INNER JOIN dictionary ON favourites.word_id = dictionary.id
      ORDER BY favourites.id DESC
      ''');
    //---------------------- TODO: Take note -----------------------------------------
    return List.generate(results.length, ((index) {
      final List<String> loadedMeanings = [];
      for (var i = 1; i <= 3; i++) {
        if (results[index]['meaning$i'] == null) {
          continue;
        }
        loadedMeanings.add(results[index]['meaning$i'].toString());
      }
      final String kana = results[index]['kana'].toString().replaceAll(
        RegExp(r"[\[\]']"),
        '',
      );
      return WordItem(
        id: results[index]['id'] as int,
        word: results[index]['word'] as String,
        ipa: results[index]['ipa'] as String,
        kana: kana,
        meanings: loadedMeanings,
      );
    }));
  } */
}

final databaseProvider =
    StateNotifierProvider<DatabaseNotifier, List<Map<String, dynamic>>>(
      (ref) => DatabaseNotifier(ref),
    );
