// ignore_for_file: prefer_const_constructors

import 'package:duo_words/pages/quiz_page.dart';
import 'package:duo_words/utils/quiz.dart';
import 'package:duo_words/utils/quiz_configuration.dart';
import 'package:duo_words/utils/word/word_cache.dart';
import 'package:duo_words/utils/word/words_http.dart';
import 'package:flutter/material.dart';

import '../utils/word/language.dart';
import '../utils/word/word.dart';
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
  bool doOnlyGenderedQuestions = false;
  bool doOnlyWrittenQuestions = false;

  bool isLoading = false;

  _MenuPageState() {
    language = Language.german;
    chapterList = getChapters(language).reversed.toList();
    chapter = chapterList.first;
  }

  void startButtonFunction() async {
    // Turn loading screen on
    setState(() {
      isLoading = true;
    });

    // Process
    List<Word> wordList = await getWordListFromDb(language, chapter);
    QuizConfiguration quizConfiguration = QuizConfiguration(
      language: language,
      chapter: chapter,
      wordList: wordList,
      isAdaptative: isAdaptative,
      hasRandomOrder: hasRandomOrder,
      doOnlyGenderedQuestions: doOnlyGenderedQuestions,
      doOnlyWrittenQuestions: doOnlyWrittenQuestions,
    );

    if (!quizConfiguration.isConfigurationCorrect()) {
      showSnackbar(context, "Quiz configuration is invalid.");
      return;
    }
    if (quizConfiguration.wordList.isEmpty) {
      showSnackbar(context, "No questions available.");
      return;
    }

    Quiz quiz = Quiz(quizConfiguration: quizConfiguration);

    // Turn loading screen off
    setState(() {
      isLoading = false;
    });

    // Navigate
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizPage(quiz: quiz),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(actions: []),
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
        StartButton(onPressed: startButtonFunction),
        SizedBox(height: 50.0),
        // Switches
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MenuSwitch(
              label: "Adaptative",
              value: isAdaptative,
              function: (bool value) {
                setState(() {
                  isAdaptative = value;
                });
              },
            ),
            MenuSwitch(
              label: "Random Order",
              value: hasRandomOrder,
              function: (bool value) {
                setState(() {
                  hasRandomOrder = value;
                });
              },
            ),
            MenuSwitch(
              label: "Only Gender Questions",
              value: doOnlyGenderedQuestions,
              function: (bool value) {
                setState(() {
                  doOnlyGenderedQuestions = value;
                  if (doOnlyGenderedQuestions) {
                    doOnlyWrittenQuestions = false;
                  }
                });
              },
            ),
            MenuSwitch(
              label: "Only Written Questions",
              value: doOnlyWrittenQuestions,
              function: (bool value) {
                setState(() {
                  doOnlyWrittenQuestions = value;
                  if (doOnlyWrittenQuestions) {
                    doOnlyGenderedQuestions = false;
                  }
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
            Text('Download/Update ${language.name} course.'),
            IconButton(
              icon: Icon(Icons.update, size: 30),
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                try {
                  await updateLocalCacheForLanguage(language);
                } catch (e) {
                  showSnackbar(context, "Could not update cache.");
                  setState(() {
                    isLoading = false;
                  });
                  return;
                }
                setState(() {
                  isLoading = false;
                });
                showSnackbar(context, "Cache updated successfuly.");
              },
              tooltip: 'Fetch Course Updates',
            ),
          ],
        ),
      ],
    );
  }
}

class StartButton extends StatelessWidget {
  final void Function() onPressed;
  const StartButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      child: Text(
        "Start Button",
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }
}

class MenuSwitch extends StatelessWidget {
  final String label;
  final bool value;
  final void Function(bool) function;

  const MenuSwitch(
      {super.key,
      required this.label,
      required this.value,
      required this.function});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: TextStyle(fontSize: 20.0)),
        SizedBox(width: 10.0),
        Switch(value: value, onChanged: function),
      ],
    );
  }
}
