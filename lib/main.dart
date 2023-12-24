// ignore_for_file: prefer_const_constructors

import 'package:duo_words/pages/menu_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Duo Words",
      debugShowCheckedModeBanner: false,
      home: const App(),
      theme: ThemeData.dark(),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuPage();
  }
}
