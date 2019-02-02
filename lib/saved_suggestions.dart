import 'package:flutter/material.dart';

class SavedSuggestions extends StatelessWidget {
  final TextStyle bigFont;
  final Set<String> saved;
  SavedSuggestions({Key key, @required this.bigFont, @required this.saved}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Iterable<ListTile> tiles = saved.map(
      (String pair) {
        return ListTile(
          title: Text(
            pair,
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