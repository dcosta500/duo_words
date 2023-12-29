// ignore_for_file: prefer_const_constructors

import 'package:duo_words/pages/quiz_page.dart';
import 'package:duo_words/utils/question/question_generator.dart';
import 'package:duo_words/utils/quiz_configuration.dart';
import 'package:duo_words/utils/word/chapter.dart';
import 'package:flutter/material.dart';

import '../utils/question/question.dart';
import '../utils/word/language.dart';
import 'consts.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Language language = Language.GERMAN; // Default language
  Chapter chapter = Chapter.S1_U1_FAMILY; // Default chapter

  bool isAdaptative = false;
  bool hasRandomOrder = false;

  void navigateToQuizPage(
      BuildContext context, List<Question> questionList, QuizConfiguration qc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizPage(questionList: questionList, qc: qc),
      ),
    );
  }

  Widget getButton(BuildContext context, String text, QuizConfiguration qc) {
    return FilledButton(
      onPressed: () async {
        List<Question> questionList = await QuestionParser.getFromDb(
            language: language, chapter: chapter);
        navigateToQuizPage(context, questionList, qc);
      },
      child: Text(text, style: TextStyle(fontSize: 20.0)),
    );
  }

  Widget getSwitch(BuildContext context, String label, bool initialValue,
      void Function(bool) function) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: TextStyle(fontSize: 20.0)),
        SizedBox(width: 10.0),
        Switch(value: initialValue, onChanged: function),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: APP_BAR,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Buttons
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getButton(
                  context,
                  "Start Quiz",
                  QuizConfiguration(
                    isAdaptative: isAdaptative,
                    hasRandomOrder: hasRandomOrder,
                  ),
                )
              ],
            ),
            SizedBox(height: 50.0),
            // Switches
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getSwitch(
                  context,
                  "Adaptative",
                  isAdaptative,
                  (bool value) {
                    setState(() {
                      isAdaptative = value;
                    });
                  },
                ),
                getSwitch(
                  context,
                  "Random Order",
                  hasRandomOrder,
                  (bool value) {
                    setState(() {
                      hasRandomOrder = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
