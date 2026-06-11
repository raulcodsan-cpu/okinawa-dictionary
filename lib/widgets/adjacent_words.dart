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
        TableRow(children: [Text('前の単語'), Text('次の単語')]),
        TableRow(
          children: [
            TextButton(
              style: ButtonStyle(
                alignment: AlignmentGeometry.centerLeft,
                padding: WidgetStatePropertyAll(
                  EdgeInsetsGeometry.symmetric(vertical: 8),
                ),
              ),
              child: Row(
                children: [
                  Text(adjacentWords[1].kana),
                  Text(
                    '[${adjacentWords[1].word}]',
                    style: TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                ],
              ),
              onPressed: () => onPressed(adjacentWords[0]),
            ),
            TextButton(
              style: ButtonStyle(
                alignment: AlignmentGeometry.centerLeft,
                padding: WidgetStatePropertyAll(
                  EdgeInsetsGeometry.symmetric(vertical: 8),
                ),
              ),
              child: Row(
                children: [
                  Text(adjacentWords[1].kana),
                  Text(
                    '[${adjacentWords[1].word}]',
                    style: TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                ],
              ),
              onPressed: () => onPressed(adjacentWords[1]),
            ),
          ],
        ),
      ],
    );
  }
}
