import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uchinaguchi_jisho/data/database_provider.dart';
import 'package:uchinaguchi_jisho/models/word_item.dart';
import 'package:uchinaguchi_jisho/widgets/entry_widget.dart';

class EntryScreen extends ConsumerStatefulWidget {
  const EntryScreen({super.key, required this.word});
  final WordItem word;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _EntryScreen();
  }
}

class _EntryScreen extends ConsumerState<EntryScreen> {
  late final PageController _pageController;
  static const int _totalEntries = 1458; //Max db rows
  late int _currentWordId;

  @override
  void initState() {
    _currentWordId = widget.word.id;
    //Convert ti 0-based
    final int clickedIndex = widget.word.id - 1;
    _pageController = PageController(initialPage: clickedIndex);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onHomePressed() {
    Navigator.of(context).popUntil(ModalRoute.withName('SearchScreen'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: onHomePressed, icon: Icon(Icons.clear_rounded)),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (globalIndex) {},
        itemBuilder: (context, globalIndex) {
          //Bring back to 1-base
          final targetId = globalIndex + 1;
          //Skip processing if same word.
          if (targetId == widget.word.id) {
            return EntryWidget(word: widget.word);
          }

          //Otherwise get next/previous from db
          return FutureBuilder<WordItem>(
            future: ref.watch(databaseProvider.notifier).searchFromId(targetId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError || !snapshot.hasData) {
                return const Center(child: Text('Error loading entry'));
              }

              return EntryWidget(word: snapshot.data!);
            },
          );
        },
      ),
    );
  }
}
