import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uchinaguchi_jisho/screens/search_screen.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 4, 42, 73),
  ),
  textTheme: TextTheme(
    //titleLarge for EntryScreen's main word.
    titleLarge: TextStyle(
      fontSize: 40,
      color: Colors.white,
      decoration: TextDecoration.none,
      fontWeight: FontWeight.normal,
    ),
    //titeMedium for SearchScreen's word list's words title.
    titleMedium: TextStyle(
      fontSize: 20,
      color: Colors.white,
      decoration: TextDecoration.none,
      fontWeight: FontWeight.normal,
      overflow: TextOverflow.ellipsis,
    ),
    //labelSmall for EntryScreen adjacent word id.
    labelSmall: TextStyle(
      fontSize: 15,
      color: Colors.white54,
      overflow: TextOverflow.ellipsis,
    ),
    //labelLarge for EntryScreen main word id.
    labelLarge: TextStyle(
      fontSize: 20,
      color: const Color.fromARGB(96, 255, 255, 255),
    ),
    //headlineMedium for adjacent words link (word).
    headlineMedium: TextStyle(
      color: Colors.blue.shade200,
      fontWeight: FontWeight.bold,
      fontSize: 17,
    ),
  ),
);

void main() {
  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      initialRoute: 'SearchScreen',
      routes: {'SearchScreen': (context) => SearchScreen()},
    );
  }
}
