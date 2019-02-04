import 'package:flutter/material.dart';
import 'package:startup_namer/pages/random_words.dart';
import 'package:startup_namer/pages/saved_suggestions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: RandomWords(),
      routes: <String, WidgetBuilder>{
        // define the routes
        SavedSuggestions.routeName: (BuildContext context) => new SavedSuggestions(),
      },
    );
  }
}
