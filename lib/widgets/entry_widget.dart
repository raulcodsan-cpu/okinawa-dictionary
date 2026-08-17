import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uchinaguchi_jisho/models/word_item.dart';
import 'package:uchinaguchi_jisho/widgets/adjacent_words.dart';

class EntryWidget extends ConsumerWidget {
  const EntryWidget({super.key, required this.words, required this.goToPage});
  final List<WordItem> words;
  final void Function(int) goToPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late WordItem currentWord;
    if (words.length == 2) {
      if (words[0].id == 1) {
        currentWord = words[0];
      } else {
        currentWord = words[1];
      }
    } else {
      currentWord = words[1];
    }

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 5.0,
        child: SingleChildScrollView(
          //----------------------- TODO: Take note ---------------------
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      currentWord.word,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '(${currentWord.id})',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 0.0, height: 30),
              Text('カナ：'),
              Row(
                children: [
                  SizedBox(width: 30, height: 0.0),
                  Text(currentWord.kana),
                ],
              ),
              Text('発音：'),
              Row(
                children: [
                  SizedBox(width: 30, height: 0.0),
                  Text(currentWord.ipa),
                ],
              ),
              Text('説明：'),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final entries in currentWord.meanings) ...[
                      //----------------------- TODO: Take note ---------------
                      Text(entries),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              AdjacentWords(words: words, goToPage: goToPage),
            ],
          ),
        ),
      ),
    );
  }
}
