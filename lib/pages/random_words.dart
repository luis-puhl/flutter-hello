import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

import 'package:startup_namer/pages/saved_suggestions.dart';
import 'package:startup_namer/support/json_placeholder_api.dart' as jpa;

class RandomWordsState extends State<RandomWords> {
  Set<String> _suggestions = Set<String>();
  final Set<String> _saved = Set<String>();
  Future<List<jpa.Todo>> todos;

  @override
  void initState() {
    super.initState();
    todos = jpa.JsonPlaceholderApi.indexTodos();
  }

  Future<void> _refresh() async {
    print('refreshing...');
    _suggestions = Set<String>();
    todos = jpa.JsonPlaceholderApi.indexTodos();
    _suggestions.addAll((await todos).map((todo) => todo.title));
    return todos;
  }

  Widget _buildTodosList() {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder<List<jpa.Todo>>(
        future: todos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // When http request is fulfilled, the titles are added to the to the list.
            _suggestions.addAll(snapshot.data.map((todo) => todo.title));
            return _buildSuggestions();
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }

          // By default, show a loading spinner
          return Center(child: CircularProgressIndicator());
        },
      ),
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
      title: Text(pair, style: const TextStyle(fontSize: 18.0),),
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
              Navigator.pushNamed(context, SavedSuggestions.routeName);
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (BuildContext context) => SavedSuggestions(saved: _saved,)
              //   )
              // );
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