import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uchinaguchi_jisho/data/database_provider.dart';

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
              itemBuilder: (context, index) =>
                  ListTile(title: Text(snapshot.data![index].word)),
            );
          },
        ),
      ),
    );
  }
}
