import 'package:flutter/material.dart';
import 'package:movies/screens/movies_details.dart';
import 'package:movies/screens/movies_list.dart';

void main() => runApp(MyApp());

final routes = {
  '/login' : (BuildContext context) => new MoviesList(),
  '/home' : (BuildContext context) => new MoviesDetails(),
  '/' : (BuildContext context) => new MoviesList()
};

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies App',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
      ),
      routes: routes,
    );
  }
}

