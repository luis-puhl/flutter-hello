import 'package:http/http.dart' as http;
import 'dart:convert';

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

class Todo {
  /*
  {
    "userId": 1,
    "id": 1,
    "title": "delectus aut autem",
    "completed": false
  },
  */
  final int userId;
  final int id;
  final String title;
  final bool completed;

  Todo({this.userId, this.id, this.title, this.completed});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }

  String toString() {
    return "{userId: ${this.userId}, id: ${this.id}, title: '${this.title}', completed: ${this.completed.toString()} }";
  }
}

class JsonPlaceholderApi {
  static Future<Todo> fetchTodo() async {
    final response = await http.get('https://jsonplaceholder.typicode.com/todos/1');

    if (response.statusCode == 200) {
      return Todo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load todo');
    }
  }

  static Future<List<Todo>> indexTodos() async {
    final response = await http.get('https://jsonplaceholder.typicode.com/todos');

    if (response.statusCode == 200) {
      List<dynamic> todosJson = json.decode(response.body);
      List<Todo> todos = [];
      todos.addAll(todosJson.map((jsonTodo) => Todo.fromJson(jsonTodo)));
      todos.shuffle();
      return todos;
    } else {
      throw Exception('Failed to index todos');
    }
  }

  static Future<Post> fetchPost() async {
    final response = await http.get('https://jsonplaceholder.typicode.com/posts/1');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      return Post.fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }
}