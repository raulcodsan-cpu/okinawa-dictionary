import 'package:flutter/material.dart';

class SearchEntry extends StatefulWidget {
  const SearchEntry({super.key, required this.word, required this.onTap});
  final Map<String, dynamic> word;
  final Function() onTap;

  @override
  State<SearchEntry> createState() => _SearchEntryState();
}

class _SearchEntryState extends State<SearchEntry> {
  @override
  Widget build(BuildContext context) {
    return Card(
      //color: Theme.of(context).canvasColor,
      //elevation: 0,
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 10,
              children: [
                Text(
                  //Some words do not have kana attached yet, so we test to empty.
                  widget.word['kana'].isNotEmpty
                      ? widget.word['kana'].toString().replaceAll(
                          RegExp(r"[\[\]']"),
                          '',
                        )
                      : widget.word['word'],
                  //Code to replaces everything that matches the Regular Expression.
                  //The syntax for RegExp:
                  //r"": raw string.
                  //Outside []: any single character to match (checklist)
                  // '\[' & '\]' : '\' escape char
                  // ' : '
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  widget.word['ipa'] ?? '',
                  style: TextStyle(fontSize: 12, color: Colors.white54),
                ),
              ],
            ),
            Container(
              alignment: AlignmentGeometry.centerLeft,
              height: 50,
              width: 200,
              child: Text(
                widget.word['meaning1'],
                style: TextStyle(fontSize: 15),
              ),
            ),
            SizedBox(width: 0.0, height: 10),
          ],
        ),
        subtitle: Text(widget.word['word']),
        hoverColor: Colors.white24,
        focusColor: Colors.white12,
        onTap: widget.onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
