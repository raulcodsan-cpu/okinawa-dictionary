import 'dart:io';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uchinaguchi_jisho/data/selected_word_provider.dart';
import 'package:uchinaguchi_jisho/models/word_item.dart';

part 'fav_provider.g.dart';

Future<Database> get database async {
  final dbPath = await getDatabasesPath();
  final filePath = 'okinawa_pandas.db';
  final path = join(dbPath, filePath);

  // Check if the database already exists in the device's local storage
  final exists = await databaseExists(path);

  if (!exists) {
    // If it doesn't exist, copy it from the assets folder
    // ('Creating a copy of the pre-populated database from assets...');

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
      // ('Database successfully copied.');
    } catch (e) {
      // ('Error copying database from assets: $e');
    }
  } else {
    // ('Database already exists on device. Opening existing database...');
  }

  // Open the newly copied database
  return await openDatabase(path);
}

@riverpod
class FavouritesNotifier extends _$FavouritesNotifier {
  @override
  Future<List<WordItem>> build() async {
    final db = await database;

    final List<Map<String, dynamic>> results = await db.rawQuery('''
      SELECT dictionary.* FROM favourites
      INNER JOIN dictionary ON favourites.word_id = dictionary.id
      ORDER BY favourites.id DESC
      ''');

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
  }

  Future<bool> isFavourite() async {
    if (!ref.mounted) {
      return false;
    }

    final word = ref.read(selectedWordProvider);
    if (word == null) {
      return false;
    }
    // ------------------------------------- TODO: Add note ----------------------
    final favourites = await future;
    return favourites.any((item) => item.id == word.id);
  }

  /*  Future<List<WordItem>> getFavouriteWords() async {
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
  }
 */

  Future<void> removeFavWord() async {
    if (!ref.mounted) {
      return;
    }

    final word = ref.read(selectedWordProvider);
    if (word == null) {
      return;
    }

    final db = await database;

    await db.execute('''
        CREATE TABLE IF NOT EXISTS favourites (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          word_id INTEGER UNIQUE
        )
      ''');

    try {
      await db.execute('DELETE FROM favourites WHERE word_id = ?', [word.id]);
    } catch (e) {
      // ('Error while deleting word: $e');
    }
    // ('Word deleted correctly');
  }

  Future<void> addFavouriteWord() async {
    if (!ref.mounted) {
      return;
    }

    final word = ref.read(selectedWordProvider);
    if (word == null) {
      return;
    }

    final db = await database;

    await db.execute('''
        CREATE TABLE IF NOT EXISTS favourites (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          word_id INTEGER UNIQUE
        )
      ''');

    try {
      await db.execute(
        'INSERT OR IGNORE INTO favourites (word_id) VALUES (?)',
        [word.id],
      );
    } catch (e) {
      //('Error while adding word: $e');
      return;
    }
    //('Word added correctly');
  }
}
