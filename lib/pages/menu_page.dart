// ignore_for_file: prefer_const_constructors

import 'package:duo_words/pages/quiz_page.dart';
import 'package:flutter/material.dart';

import 'consts.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  void navigateToQuizPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QuizPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: APP_BAR,
      body: Center(
        child: FilledButton(
          onPressed: () {
            navigateToQuizPage(context);
          },
          child: Text("Start Quiz"),
        ),
      ),
    );
  }
}
