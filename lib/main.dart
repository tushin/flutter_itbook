import 'package:flutter/material.dart';

import 'home_page.dart';
import 'search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      initialRoute: "/",
      routes: {
        '/': (context) => const HomePage(),
        '/search': (context) => const SearchPage(),
      },
    );
  }
}
