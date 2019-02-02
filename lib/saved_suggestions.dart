import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class SavedSuggestions extends StatelessWidget {
  final TextStyle bigFont;
  final Set<WordPair> saved;
  SavedSuggestions({Key key, @required this.bigFont, @required this.saved}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Iterable<ListTile> tiles = saved.map(
      (WordPair pair) {
        return ListTile(
          title: Text(
            pair.asPascalCase,
            style: bigFont,
          ),
        );
      }
    );
    final List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Suggestions'),),
      body: ListView(children: divided),
    );
  }
}