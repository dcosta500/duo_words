// ignore_for_file: prefer_const_constructors

import 'package:duo_words/pages/quiz_page.dart';
import 'package:duo_words/utils/question/question_parser.dart';
import 'package:duo_words/utils/quiz_configuration.dart';
import 'package:duo_words/utils/word_cache.dart';
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
  late Language language = Language.german; // Default language
  late List<Chapter> chapterList;
  late Chapter chapter; // Default chapter

  bool isAdaptative = false;
  bool hasRandomOrder = false;
  bool isLoading = false;

  _MenuPageState() {
    language = Language.german;
    chapterList = getChapters(language).reversed.toList();
    chapter = chapterList.first;
  }

  void navigateToQuizPage(
      BuildContext context, List<Question> questionList, QuizConfiguration qc) {
    if (questionList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No questions available.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
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
        setState(() {
          isLoading = true;
        });
        List<Question> questionList = await QuestionParser.getFromDb(
            language: language, chapter: chapter);
        setState(() {
          isLoading = false;
        });
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
        child: isLoading
            ? CircularProgressIndicator() // Show loading indicator when isLoading is true
            : buildContent(context), // Otherwise, show the main content
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return Column(
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
        SizedBox(height: 50.0),
        // Additional Operations
        DropdownButton<Language>(
          dropdownColor: Colors.black,
          value: language,
          onChanged: (Language? newValue) {
            setState(() {
              List<Chapter> auxList = getChapters(newValue!).reversed.toList();
              if (auxList.isEmpty) {
                printd("No chapters defined for ${newValue.name}.");
                return;
              }

              language = newValue;
              chapterList = auxList;
              chapter = chapterList.first;
            });
          },
          items:
              Language.values.map<DropdownMenuItem<Language>>((Language value) {
            return DropdownMenuItem<Language>(
              value: value,
              child:
                  Text(value.name[0].toUpperCase() + value.name.substring(1)),
            );
          }).toList(),
        ),
        DropdownButton<Chapter>(
          dropdownColor: Colors.black,
          value: chapter,
          onChanged: (Chapter? newValue) {
            setState(() {
              chapter = newValue!;
            });
          },
          items: chapterList.map<DropdownMenuItem<Chapter>>((Chapter value) {
            return DropdownMenuItem<Chapter>(
              value: value,
              child: Text(value.getPresentationString()),
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Update ${language.name} course'),
            IconButton(
              icon: Icon(Icons.update, size: 30),
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                await updateLocalCacheForLanguage(language);
                setState(() {
                  isLoading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Cache updated."),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              tooltip: 'Fetch Course Updates',
            ),
          ],
        ),
      ],
    );
  }
}
