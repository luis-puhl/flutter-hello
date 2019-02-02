import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

import 'package:startup_namer/saved_suggestions.dart';
import 'package:startup_namer/json_placeholder_api.dart' as jpa;

class RandomWordsState extends State<RandomWords> {
  final Set<String> _suggestions = Set<String>();
  final TextStyle _bigFont = const TextStyle(fontSize: 18.0);
  final Set<String> _saved = Set<String>();
  Future<jpa.Post> post;
  Future<List<jpa.Todo>> todos;

  @override
  void initState() {
    super.initState();
    print('initState');
    post = jpa.JsonPlaceholderApi.fetchPost();
    todos = jpa.JsonPlaceholderApi.indexTodos();
  }

  Widget _buildTodosList() {
    return FutureBuilder<List<jpa.Todo>>(
      future: todos,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _suggestions.addAll(snapshot.data.map((todo) => todo.title));
          return _buildSuggestions();
        } else if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }

        // By default, show a loading spinner
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  void _moreSuggestions() {
    _suggestions.addAll(generateWordPairs().take(10).map((pair) => pair.asPascalCase));
  }

  Widget _buildSuggestions(){
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();

        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _moreSuggestions();
        }
        return _buildRow(_suggestions.elementAt(index), index);
      },
    );
  }

  Widget _buildRow(String pair, num index) {
    final bool alreadySaved = _saved.contains(pair);
    return ListTile(
      leading: Text('#' + index.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
      title: Text(
        pair,
        style: _bigFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => SavedSuggestions(bigFont: _bigFont, saved: _saved,)
                )
              );
            },
          )
        ],
      ),
      body: _buildTodosList(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}