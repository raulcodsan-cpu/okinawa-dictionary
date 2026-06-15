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

    void onAdjacentPressed(WordItem adjacentWord) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EntryScreen(word: adjacentWord),
        ),
      );
    }

    void onHomePressed() {
      Navigator.of(context).popUntil(ModalRoute.withName('SearchScreen'));
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: onHomePressed, icon: Icon(Icons.clear_rounded)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    word.word,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '(${word.id})',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
            ),
            SizedBox(width: 0.0, height: 50),
            Text('カナ：'),
            Row(children: [SizedBox(width: 30, height: 0.0), Text(word.kana)]),
            Text('発音：'),
            Row(children: [SizedBox(width: 30, height: 0.0), Text(word.ipa)]),
            Text('説明：'),
            Row(
              children: [
                SizedBox(width: 30, height: 0.0),
                Expanded(
                  child: Text(
                    word.meaning1,
                    // --------------------------  Check explanation getting cut ------------------------------
                    //maxLines: 6,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            SizedBox(width: 0.0, height: 40),
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
                  onPressed: onAdjacentPressed,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
