import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uchinaguchi_jisho/models/word_item.dart';
import 'package:uchinaguchi_jisho/widgets/adjacent_words.dart';

class EntryWidget extends ConsumerWidget {
  const EntryWidget({
    super.key,
    required this.word,
    required this.onAdjacentPressed,
  });
  final WordItem word;
  final Function onAdjacentPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              SizedBox(width: 0.0, height: 30),
              Text('カナ：'),
              Row(
                children: [SizedBox(width: 30, height: 0.0), Text(word.kana)],
              ),
              Text('発音：'),
              Row(children: [SizedBox(width: 30, height: 0.0), Text(word.ipa)]),
              Text('説明：'),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final entries in word.meanings) ...[
                      //----------------------- TODO: Take note ---------------
                      Text(entries),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              AdjacentWords(
                key: ValueKey(word),
                onAdjacentPressed: onAdjacentPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
