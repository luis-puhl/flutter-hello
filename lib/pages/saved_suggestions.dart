import 'package:flutter/material.dart';

class SavedSuggestions extends StatelessWidget {
  static const routeName = '/saved';
  static const bigFont = TextStyle(fontSize: 18.0);
  
  final Set<String> saved = Set();

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