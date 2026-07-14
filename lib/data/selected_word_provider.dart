import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uchinaguchi_jisho/models/word_item.dart';
import 'package:uchinaguchi_jisho/data/database_provider.dart';

class SelectedWordNotifier extends Notifier<WordItem?> {
  late List<WordItem> adjacentWords;

  @override
  WordItem? build() => null; // Initial state: no selection

  void select(WordItem word) async {
    state = word;
    adjacentWords = await ref
        .read(databaseProvider.notifier)
        .searchAdjacent(state!.id);
  }

  List<WordItem> get getAdjacent => adjacentWords;
}

final selectedWordProvider = NotifierProvider<SelectedWordNotifier, WordItem?>(
  SelectedWordNotifier.new,
);
