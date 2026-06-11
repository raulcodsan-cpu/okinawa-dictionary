import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uchinaguchi_jisho/data/database_provider.dart';
import 'package:uchinaguchi_jisho/models/word_item.dart';
import 'package:uchinaguchi_jisho/widgets/adjacent_words.dart';

class EntryScreen extends ConsumerWidget {
  const EntryScreen({super.key, required this.word});
  final WordItem word;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<List<WordItem>> adjacentWords = ref
        .read(databaseProvider.notifier)
        .searchAdjacent(word.id);

    void onPressed(WordItem adjacentWord) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EntryScreen(word: adjacentWord),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Center(
              child: Text(
                word.word,
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(width: 0.0, height: 50),
            Text('カナ：'),
            Row(
              children: [
                SizedBox(width: 50, height: 0.0),
                Text(word.kana.toString().replaceAll(RegExp(r"[\[\]']"), '')),
              ],
            ),
            Text('発音：'),
            Row(children: [SizedBox(width: 50, height: 0.0), Text(word.ipa)]),
            Text('説明：'),
            Row(
              children: [
                SizedBox(width: 50, height: 0.0),
                Expanded(
                  child: Text(
                    word.meaning1,
                    maxLines: 3,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            SizedBox(width: 0.0, height: 40),
            /* Row(
              children: [
                Text('次の項目：'),
                SizedBox(width: 40, height: 0.0),
                Text('前の項目：'),
              ],
            ), */
            FutureBuilder(
              future: adjacentWords,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError || snapshot.data!.isEmpty) {
                  return Center(child: Text('Error retrieving adjacent words'));
                }

                return AdjacentWords(
                  adjacentWords: snapshot.data!,
                  onPressed: onPressed,
                );

                /* Table(
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
                          child: Text(snapshot.data![0].kana),
                          onPressed: () => onPressed(snapshot.data![0]),
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
                              Text(snapshot.data![1].kana),
                              Text('[${snapshot.data![1].word}]',style: TextStyle(fontSize: 12, color: Colors.white54))
                            ],
                          ),
                          onPressed: () => onPressed(snapshot.data![1]),
                        ),
                      ],
                    ),
                  ],
                ); */
              },
            ),
          ],
        ),
      ),
    );
  }
}
