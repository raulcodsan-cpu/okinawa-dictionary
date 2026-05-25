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
    return Hero(
      tag: widget.word['okinawan'],
      child: Card(
        //color: Theme.of(context).canvasColor,
        //elevation: 0,
        child: ListTile(
          title: Row(
            spacing: 10,
            children: [
              Text(
                widget.word['okinawan'],
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                '「Alphabet pronuntiantion」',
                style: TextStyle(fontSize: 12, color: Colors.white54),
              ),
            ],
          ),
          subtitle: Text(widget.word['japanese']),
          hoverColor: Colors.white24,
          focusColor: Colors.white12,
          onTap: widget.onTap,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
      ),
    );
  }
}
