// ignore_for_file: prefer_const_constructors

import 'package:duo_words/pages/quizPage.dart';
import 'package:flutter/material.dart';

import 'consts.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: APP_BAR,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Hello World!"),
            SizedBox(height: 30),
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizPage(),
                  ),
                );
              },
              child: Text("Other Page"),
            ),
          ],
        ),
      ),
    );
  }
}
