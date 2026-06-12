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
    return Table(
      children: [
        TableRow(
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
                Text('次の単語', textAlign: TextAlign.start),
                Text(
                  '(${nextWord.id.toString()})',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ],
        ),
        TableRow(
          children: [
            TextButton(
              style: ButtonStyle(
                alignment: AlignmentGeometry.bottomLeft,
                padding: WidgetStatePropertyAll(
                  EdgeInsetsGeometry.only(top: 8),
                ),
              ),
              child: Text(
                previousWord.kana,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              onPressed: () => onPressed(previousWord),
            ),
            TextButton(
              style: ButtonStyle(
                alignment: AlignmentGeometry.bottomLeft,
                padding: WidgetStatePropertyAll(
                  EdgeInsetsGeometry.only(top: 8),
                ),
              ),
              child: Text(
                nextWord.kana,
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
