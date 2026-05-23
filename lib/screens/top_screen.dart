import 'package:flutter/material.dart';
import 'package:uchinaguchi_jisho/screens/jap_search_screen.dart';

class TopScreen extends StatelessWidget {
  const TopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 30,
            children: [
              ListTile(
                title: Text('検索（標準語➞うちなぐち）'),
                tileColor: Theme.of(context).colorScheme.onPrimary,
                leading: Icon(Icons.search),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(20),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => JapSearchScreen()),
                  );
                },
              ),
              ListTile(
                title: Text('検索（うちなぐち➞標準語'),
                tileColor: Theme.of(context).colorScheme.onPrimary,
                leading: Icon(Icons.search),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(20),
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text('本日の言葉'),
                tileColor: Theme.of(context).colorScheme.onPrimary,
                leading: Icon(Icons.star),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(20),
                ),
                onTap: () {},
              ),
              SizedBox(height: 150),
            ],
          ),
        ),
      ),
    );
  }
}
