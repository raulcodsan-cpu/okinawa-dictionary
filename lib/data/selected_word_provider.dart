import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uchinaguchi_jisho/models/word_item.dart';

class SelectedWordNotifier extends Notifier<WordItem?> {
  late List<WordItem> adjacentWords;

  @override
  WordItem? build() => null; // Initial state: no selection

  /*   void select(List<WordItem> words) async {
    state = words[1];
    adjacentWords = [words[0], words[2]];
  } */

  /*   Future<List<WordItem>> get getAdjacent async {
    adjacentWords = await ref
        .read(databaseProvider.notifier)
        .searchAdjacent(state!.id);

    return adjacentWords;
  }
} */
}

final selectedWordProvider = NotifierProvider<SelectedWordNotifier, WordItem?>(
  SelectedWordNotifier.new,
);
