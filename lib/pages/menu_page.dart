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
  late String language = ""; // Default language
  late List<Chapter> chapterList;
  late String chapter; // Default chapter

  bool isAdaptative = false;
  bool hasRandomOrder = false;
  bool doOnlyGenderedQuestions = false;
  bool doOnlyWrittenQuestions = false;

  bool isLoading = false;

  _MenuPageState();

  @override
  void initState() {
    super.initState();
    isLoading = true;
    _loadFromCache();
  }

  Future<void> _loadFromCache() async {
    await readChaptersOfLanguageFromLocalCache();
    language = chaptersOfLanguage.isEmpty ? "" : chaptersOfLanguage.keys.first;
    chapterList =
        chaptersOfLanguage.isEmpty ? [] : chaptersOfLanguage[language]!;

    chapter = chapterList.isEmpty ? "" : chapterList.last.name;
    setState(() {
      isLoading = false;
    });
  }

  void startButtonFunction() async {
    if (chaptersOfLanguage.isEmpty) return;

    // Turn loading screen on
    setState(() {
      isLoading = true;
    });

    // Process
    List<Word> wordList = await getWordListFromDb(language, chapter);
    QuizConfiguration quizConfiguration = QuizConfiguration(
      wordList: wordList,
      isAdaptative: isAdaptative,
      hasRandomOrder: hasRandomOrder,
      doOnlyGenderedQuestions: doOnlyGenderedQuestions,
      doOnlyWrittenQuestions: doOnlyWrittenQuestions,
    );

    if (!quizConfiguration.isConfigurationCorrect()) {
      showSnackbar(context, "Quiz configuration is invalid.");
      setState(() {
        isLoading = false;
      });
      return;
    }
    if (quizConfiguration.wordList.isEmpty) {
      showSnackbar(context, "No questions available.");
      setState(() {
        isLoading = false;
      });
      return;
    }

    Quiz quiz = Quiz(quizConfiguration: quizConfiguration);

    if (!quiz.hasQuestions()) {
      showSnackbar(context, "No questions available.");
      setState(() {
        isLoading = false;
      });
      return;
    }

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
        chaptersOfLanguage.isNotEmpty && !isLoading
            ? DropdownButton<String>(
                dropdownColor: Colors.black,
                value: language,
                onChanged: (String? newValue) {
                  setState(() {
                    List<Chapter> auxList =
                        chaptersOfLanguage[newValue!]!.reversed.toList();
                    if (auxList.isEmpty) {
                      printd("No chapters defined for ${newValue}.");
                      return;
                    }

                    language = newValue;
                    chapterList = auxList;
                    chapter = chapterList.first.name;
                  });
                },
                items: chaptersOfLanguage.keys
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value[0].toUpperCase() + value.substring(1)),
                  );
                }).toList(),
              )
            : SizedBox.shrink(),
        chaptersOfLanguage.isNotEmpty && !isLoading
            ? DropdownButton<String>(
                dropdownColor: Colors.black,
                value: chapter,
                onChanged: (String? newValue) {
                  setState(() {
                    chapter = newValue!;
                  });
                },
                items: chapterList
                    .map<DropdownMenuItem<String>>((Chapter value) {
                      return DropdownMenuItem<String>(
                        value: value.name,
                        child: Text(getPresentationString(value.name)),
                      );
                    })
                    .toList()
                    .reversed
                    .toList(),
              )
            : SizedBox.shrink(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Download/Update courses.'),
            IconButton(
              icon: Icon(Icons.update, size: 30),
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                try {
                  await updateLocalLanguageCache();
                  language = chaptersOfLanguage.isEmpty
                      ? ""
                      : chaptersOfLanguage.keys.first;
                  chapterList = chaptersOfLanguage.isEmpty
                      ? []
                      : chaptersOfLanguage[language]!;

                  chapter = chapterList.isEmpty ? "" : chapterList.last.name;
                } catch (e) {
                  showSnackbar(context, "Could not update cache. $e");
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
