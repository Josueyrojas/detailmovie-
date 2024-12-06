import 'package:flutter/material.dart';
import 'screens/movie_list.dart';
import 'screens/favorite_movies.dart';

void main() {
  runApp(const MoviesApp());
}

class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MovieList(),
        '/favorites': (context) =>  FavoritesScreen(),
      },
    );
  }
}