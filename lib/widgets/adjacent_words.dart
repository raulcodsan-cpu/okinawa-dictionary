import 'package:flutter/material.dart';
import 'package:uchinaguchi_jisho/models/word_item.dart';

class AdjacentWords extends StatelessWidget {
  const AdjacentWords({
    super.key,
    required this.adjacentWords,
    required this.onPressed,
  });
  final List<WordItem> adjacentWords;
  final Function(WordItem word) onPressed;

  @override
  Widget build(BuildContext context) {
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
              onPressed: () => onPressed(previousWord),
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
              onPressed: () => onPressed(nextWord),
            ),
          ],
        ),
      ],
    );
  }
}
