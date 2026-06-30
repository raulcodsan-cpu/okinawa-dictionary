import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uchinaguchi_jisho/data/selected_word_provider.dart';
import 'package:uchinaguchi_jisho/models/word_item.dart';
import 'package:uchinaguchi_jisho/screens/entry_screen.dart';

class AdjacentWords extends ConsumerStatefulWidget {
  const AdjacentWords({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AdjacentWords();
  }
}

class _AdjacentWords extends ConsumerState<AdjacentWords> {
  List<WordItem> adjacentWords = [];

  @override
  void initState() {
    adjacentWords = ref.watch(selectedWordProvider.notifier).getAdjacent;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void onAdjacentPressed(WordItem adjacentWord) {
      ref.watch(selectedWordProvider.notifier).select(adjacentWord);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EntryScreen(word: adjacentWord),
        ),
      );
    }

    final previousWord = adjacentWords[0];
    final nextWord = adjacentWords[1];
    final previousHasComma = previousWord.kana.contains(',');
    final nextHasComma = nextWord.kana.contains(',');

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('前の単語', textAlign: TextAlign.start),
            Text(
              '(${previousWord.id.toString()})',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 30),
            TextButton(
              style: ButtonStyle(
                alignment: AlignmentGeometry.topLeft,
                padding: WidgetStatePropertyAll(
                  EdgeInsetsGeometry.only(top: 8),
                ),
              ),
              child: Text(
                textAlign: TextAlign.start,
                previousHasComma
                    ? previousWord.kana.split(',')[0]
                    : previousWord.kana,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              onPressed: () => onAdjacentPressed(previousWord),
            ),
          ],
        ),

        Row(
          children: [
            Text('次の単語', textAlign: TextAlign.start),
            Text(
              '(${nextWord.id.toString()})',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),

        Row(
          children: [
            const SizedBox(width: 30),
            TextButton(
              style: ButtonStyle(
                alignment: AlignmentGeometry.topLeft,
                padding: WidgetStatePropertyAll(
                  EdgeInsetsGeometry.only(top: 8),
                ),
              ),
              child: Text(
                nextHasComma ? nextWord.kana.split(',')[0] : nextWord.kana,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              onPressed: () => onAdjacentPressed(nextWord),
            ),
          ],
        ),
      ],
    );
  }
}
