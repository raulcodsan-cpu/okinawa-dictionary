import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uchinaguchi_jisho/data/selected_word_provider.dart';
import 'package:uchinaguchi_jisho/models/word_item.dart';
import 'package:uchinaguchi_jisho/widgets/entry_widget.dart';

class EntryScreen extends ConsumerStatefulWidget {
  EntryScreen({super.key, required this.word});
  //Word not required, if available pass value, if not call provider.
  WordItem word;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _EntryScreen();
  }
}

class _EntryScreen extends ConsumerState<EntryScreen> {
  final PageController pageController = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    List<EntryWidget> screenPages = [];
    List<WordItem> adjacentWords = ref
        .read(selectedWordProvider.notifier)
        .adjacentWords;
    for (var words in adjacentWords) {
      screenPages.add(EntryWidget(word: words));
    }
    final previousWord = adjacentWords[0];
    final nextWord = adjacentWords[1];

    void onPageChanged(int value) {
      if (value == 0) {
        setState(() {
          widget.word = previousWord;
          ref.read(selectedWordProvider.notifier).select(previousWord);
        });
      } else if (value == 2) {
        setState(() {
          widget.word = nextWord;
          ref.read(selectedWordProvider.notifier).select(nextWord);
        });
      }
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
      body: PageView(
        //--------------------- TODO: Take note ---------------------------------
        controller: pageController,
        onPageChanged: (value) => onPageChanged(value),
        children: screenPages,
      ),
    );
  }
}
