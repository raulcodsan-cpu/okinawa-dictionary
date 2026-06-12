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
    return Table(
      children: [
        TableRow(
          children: [
            Row(
              children: [
                Text('前の単語', textAlign: TextAlign.start),
                Text(
                  '(${adjacentWords[0].id.toString()})',
                  style: TextStyle(fontSize: 15, color: Colors.white54),
                ),
              ],
            ),
            Row(
              children: [
                Text('次の単語', textAlign: TextAlign.start),
                Text(
                  '(${adjacentWords[1].id.toString()})',
                  style: TextStyle(fontSize: 15, color: Colors.white54),
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
              child: Text(adjacentWords[1].kana),
              onPressed: () => onPressed(adjacentWords[0]),
            ),
            TextButton(
              style: ButtonStyle(
                alignment: AlignmentGeometry.bottomLeft,
                padding: WidgetStatePropertyAll(
                  EdgeInsetsGeometry.only(top: 8),
                ),
              ),
              child: Text(adjacentWords[1].kana),
              onPressed: () => onPressed(adjacentWords[1]),
            ),
          ],
        ),
        /* TableRow(
          children: [
            Text(
              '[${adjacentWords[0].word}]',
              style: TextStyle(fontSize: 15, color: Colors.white54),
            ),
            Text(
              '[${adjacentWords[1].word}]',
              style: TextStyle(fontSize: 15, color: Colors.white54),
            ),
          ],
        ), */
      ],
    );
  }
}
