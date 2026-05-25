import 'package:flutter/material.dart';

class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key, required this.word});
  final Map<String, dynamic> word;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Center(
              child: Hero(
                tag: word['okinawan'],
                child: Text(
                  word['okinawan'],
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(width: 0.0, height: 50),
            Text('意味：'),
            Row(
              children: [
                SizedBox(width: 50, height: 0.0),
                Text(word['japanese']),
              ],
            ),
            Text('発音：'),
            Row(
              children: [
                SizedBox(width: 50, height: 0.0),
                Text('Pronuntiation guide in IPA'),
              ],
            ),
            Text('説明：'),
            Row(
              children: [
                SizedBox(width: 50, height: 0.0),
                Expanded(
                  child: Text(
                    'Explanation\nbox with\nmax 3 lines',
                    maxLines: 3,
                  ),
                ),
              ],
            ),
            SizedBox(width: 0.0, height: 40),
            Text('こちらも：'),
            Row(
              spacing: 10,
              children: [
                SizedBox(width: 20, height: 0.0),
                Text('RelatedWord1'),
                Text('RelatedWord2'),
                Text('RelatedWord3'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
