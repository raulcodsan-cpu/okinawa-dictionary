import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uchinaguchi_jisho/data/database_provider.dart';
import 'package:uchinaguchi_jisho/data/fav_provider.dart';
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
  bool isFavourite = false;
  late List<WordItem> cachedWords;

  void onHomePressed() {
    Navigator.of(context).pop();
  }

  void _goToPage(int id) {
    _pageController.jumpToPage(id - 1);
  }

  @override
  void initState() {
    //Convert ti 0-based
    final int clickedIndex = widget.word.id - 1;
    _pageController = PageController(initialPage: clickedIndex);
    updateFav(widget.word);

    super.initState();
  }

  void updateFav(WordItem word) async {
    final favourite = await ref
        .read(favouritesProvider.notifier)
        .isFavourite(word);
    if (mounted) {
      setState(() {
        isFavourite = favourite;
      });
    }
    print("On updateFav: ${word.word}");
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WordItem currentWord = widget.word;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              if (isFavourite) {
                setState(() {
                  ref
                      .watch(favouritesProvider.notifier)
                      .removeFavWord(currentWord);
                  isFavourite = false;
                  print('On fav button push: ${currentWord.word}');
                });
              } else {
                setState(() {
                  ref
                      .read(favouritesProvider.notifier)
                      .addFavouriteWord(currentWord);
                  isFavourite = true;
                  print('On fav button push: ${currentWord.word}');
                });
              }
            },
            icon: isFavourite
                ? Icon(Icons.bookmark_added_sharp)
                : Icon(Icons.bookmark_outline_sharp),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.share)),
          IconButton(onPressed: onHomePressed, icon: Icon(Icons.clear_rounded)),
        ],
      ),
      body: PageView.builder(
        onPageChanged: (value) {
          setState(() {
            updateFav(currentWord);
          });
        },
        //dragStartBehavior: DragStartBehavior.start,
        controller: _pageController,
        itemBuilder: (context, globalIndex) {
          //Bring back to 1-base
          return FutureBuilder(
            future: ref
                .watch(oldDatabaseProvider.notifier)
                .searchFromId(globalIndex + 1),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                cachedWords = snapshot.data!;

                currentWord = snapshot.data![1];
                print("On Listview build: ${currentWord.word}");
                return EntryWidget(word: snapshot.data!, goToPage: _goToPage);
              }
              return Center(child: const Text('Error'));
            },
          );
        },
      ),
    );
  }
}
