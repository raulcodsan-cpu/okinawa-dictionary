import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uchinaguchi_jisho/models/word_item.dart';
import 'dictionary_repository.dart'; // Adjust path as needed

// 1. Provider for the repository
final dictionaryRepositoryProvider = Provider<DictionaryRepository>((ref) {
  return DictionaryRepository();
});

// 2. FutureProvider.family returning AsyncValue<List<WordItem>> for a wordId
final wordFromIdProvider = FutureProvider.family<List<WordItem>, int>((
  ref,
  wordId,
) async {
  final repository = ref.watch(dictionaryRepositoryProvider);
  return repository.searchFromId(wordId);
});

// 3. Optional: Search query provider
final searchWordsProvider = FutureProvider.family<List<WordItem>, String>((
  ref,
  query,
) async {
  final repository = ref.watch(dictionaryRepositoryProvider);
  return repository.searchWords(query);
});
