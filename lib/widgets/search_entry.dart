import 'package:flutter/material.dart';
import 'package:uchinaguchi_jisho/models/word_item.dart';
import 'package:auto_size_text/auto_size_text.dart';

class SearchEntry extends StatefulWidget {
  const SearchEntry({super.key, required this.word, required this.onTap});
  final WordItem word;
  final Function() onTap;

  @override
  State<SearchEntry> createState() => _SearchEntryState();
}

class _SearchEntryState extends State<SearchEntry> {
  final bodyFontGroup = AutoSizeGroup();

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
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 220),
                  child: AutoSizeText(
                    //Some words do not have kana attached yet, so we test to empty.
                    widget.word.kana.isNotEmpty
                        ? widget.word.kana
                        : widget.word.word,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.word.ipa,
                    style: Theme.of(context).textTheme.labelSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Container(
              alignment: AlignmentGeometry.centerLeft,
              height: 50,
              width: 300,
              child: AutoSizeText(
                maxLines: 2,
                widget.word.meanings[0],
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                group: bodyFontGroup,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 0.0, height: 5),
          ],
        ),
        subtitle: SizedBox(
          height: 20,
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(widget.word.word), Text(widget.word.id.toString())],
          ),
        ),
        hoverColor: Colors.white24,
        focusColor: Colors.white12,
        onTap: widget.onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
