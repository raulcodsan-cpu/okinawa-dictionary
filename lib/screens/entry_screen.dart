import 'package:flutter/gestures.dart';
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

  void onAdjacentPressed(int id) {
    _pageController.jumpToPage(id - 1);
  }

  @override
  void initState() {
    //Convert ti 0-based
    final int clickedIndex = widget.word.id - 1;
    _pageController = PageController(initialPage: clickedIndex);
    updateFav();

    // ------------------------------------ TODO: Take note ----------------------------
    super.initState();
  }

  void updateFav() async {
    final favourite = await ref.read(favouritesProvider.notifier).isFavourite();
    if (mounted) {
      setState(() {
        isFavourite = favourite;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onHomePressed() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              if (isFavourite) {
                setState(() {
                  ref.watch(favouritesProvider.notifier).removeFavWord();
                  isFavourite = false;
                });
              } else {
                setState(() {
                  ref.read(favouritesProvider.notifier).addFavouriteWord();
                  isFavourite = true;
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
        onPageChanged: (value) => updateFav(),
        dragStartBehavior: DragStartBehavior.start,
        controller: _pageController,
        itemBuilder: (context, globalIndex) {
          //Bring back to 1-base
          final targetId = globalIndex + 1;

          //Get next/previous from db
          return FutureBuilder<WordItem>(
            future: ref.watch(databaseProvider.notifier).searchFromId(targetId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError || !snapshot.hasData) {
                return const Center(child: Text('Error loading entry'));
              }

              return EntryWidget(
                key: ValueKey(snapshot.data),
                word: snapshot.data!,
                onAdjacentPressed: onAdjacentPressed,
              );
            },
          );
        },
      ),
    );
  }
}
