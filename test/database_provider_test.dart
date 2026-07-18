import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uchinaguchi_jisho/data/selected_word_provider.dart';
import 'package:uchinaguchi_jisho/data/database_provider.dart';
import 'package:uchinaguchi_jisho/models/word_item.dart';

// 1. Create Mock Classes
class MockDatabase extends Mock implements Database {}

// Corrected Mocktail syntax:
class FakeSelectedWordNotifier extends SelectedWordNotifier {
  WordItem? capturedWord; // Variable to track what was passed to select()

  @override
  WordItem? build() {
    return null; // Return your normal initial state here
  }

  @override
  void select(WordItem word) {
    capturedWord = word; // Capture the word so we can assert it later
  }
}

void main() {
  late MockDatabase mockDb;
  late FakeSelectedWordNotifier fakeSelectedWordNotifier;
  late ProviderContainer container;

  setUp(() {
    mockDb = MockDatabase();
    fakeSelectedWordNotifier = FakeSelectedWordNotifier();

    DatabaseNotifier.mockDatabase = mockDb;

    container = ProviderContainer(
      overrides: [
        // Inject the fake instead of the mock
        selectedWordProvider.overrideWith(() => fakeSelectedWordNotifier),
      ],
    );
  });

  tearDown(() {
    container.dispose();
    DatabaseNotifier.mockDatabase = null;
  });

  group('DatabaseNotifier search tests', () {
    test(
      'searchWords returns parsed WordItems and cleans up kana formatting',
      () async {
        // Arrange: Stub the db.query to return a fake SQLite row
        when(
          () => mockDb.query(
            'dictionary',
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
          ),
        ).thenAnswer(
          (_) async => [
            {
              'id': 1,
              'word': 'はいさい',
              'ipa': 'haisai',
              'kana': '[ハイサイ]', // Includes brackets to test the RegExp cleanup
              'meaning1': 'hello',
              'meaning2': 'hi',
              'meaning3': null,
            },
          ],
        );

        // Act
        final notifier = container.read(databaseProvider.notifier);
        final results = await notifier.searchWords('はい');

        // Assert
        expect(results.length, 1);

        final word = results.first;
        expect(word.id, 1);
        expect(word.word, 'はいさい');
        expect(word.kana, 'ハイサイ'); // Verifies the RegExp(r"[\[\]']") worked
        expect(word.meanings, [
          'hello',
          'hi',
        ]); // Verifies null meaning3 was skipped
      },
    );

    test(
      'searchAdjacent returns previous and next words based on ID',
      () async {
        // Arrange
        final wordId = 5;
        when(
          () => mockDb.query(
            'dictionary',
            where: 'id IN (?, ?)',
            whereArgs: [wordId + 1, wordId - 1],
          ),
        ).thenAnswer(
          (_) async => [
            {
              'id': 4,
              'word': 'word4',
              'ipa': '',
              'kana': 'kana4',
              'meaning1': 'meaning4',
            },
            {
              'id': 6,
              'word': 'word6',
              'ipa': '',
              'kana': 'kana6',
              'meaning1': 'meaning6',
            },
          ],
        );

        // Act
        final notifier = container.read(databaseProvider.notifier);
        final results = await notifier.searchAdjacent(wordId);

        // Assert
        expect(results.length, 2);
        expect(results[0].id, 4);
        expect(results[1].id, 6);
      },
    );

    test(
      'searchFromId fetches word and updates selectedWordProvider',
      () async {
        // Arrange
        when(
          () => mockDb.query('dictionary', where: 'id IN (?)', whereArgs: [10]),
        ).thenAnswer(
          (_) async => [
            {
              'id': 10,
              'word': 'めんそーれ',
              'ipa': 'mensoore',
              'kana': 'メンソーレ',
              'meaning1': 'welcome',
            },
          ],
        );

        // Act
        final notifier = container.read(databaseProvider.notifier);
        final result = await notifier.searchFromId(10);

        // Assert: Verify the returned word
        expect(result.id, 10);
        expect(result.word, 'めんそーれ');

        // Assert: Verify that it triggered the cross-provider interaction
        expect(fakeSelectedWordNotifier.capturedWord, equals(result));
      },
    );
  });
}
