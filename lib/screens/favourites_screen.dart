import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uchinaguchi_jisho/data/database_provider.dart';
import 'package:uchinaguchi_jisho/data/selected_word_provider.dart';
import 'package:uchinaguchi_jisho/screens/entry_screen.dart';
import 'package:uchinaguchi_jisho/widgets/search_entry.dart';

class FavouritesScreen extends ConsumerWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: FutureBuilder(
          future: ref.watch(databaseProvider.notifier).getFavouriteWords(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('There is an Error');
            }
            if (snapshot.data == null) {
              return Text('Empty');
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => SearchEntry(
                word: snapshot.data![index],
                onTap: () async {
                  ref
                      .read(selectedWordProvider.notifier)
                      .select(snapshot.data![index]);
                  await Navigator.of(context).push(
                    DialogRoute(
                      context: context,
                      builder: (context) =>
                          EntryScreen(word: snapshot.data![index]),
                    ),
                  );
                  // --------------------- TODO: Take note -----------------------------
                  ref.invalidate(databaseProvider);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
