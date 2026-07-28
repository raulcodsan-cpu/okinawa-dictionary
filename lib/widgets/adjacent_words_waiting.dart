import 'package:flutter/material.dart';

class AdjacentWordsWaiting extends StatelessWidget {
  const AdjacentWordsWaiting({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [Text('前の単語', textAlign: TextAlign.start)]),
        Row(children: [const SizedBox(width: 30), CircularProgressIndicator()]),

        Row(children: [Text('次の単語', textAlign: TextAlign.start)]),

        Row(children: [const SizedBox(width: 30), CircularProgressIndicator()]),
      ],
    );
  }
}
