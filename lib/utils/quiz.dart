import 'dart:math';

import 'package:duo_words/utils/question/question.dart';
import 'package:duo_words/utils/question/question_parser.dart';
import 'package:duo_words/utils/quiz_configuration.dart';
import 'package:duo_words/utils/word/word.dart';
import 'package:flutter/material.dart';

class Quiz {
  // If quiz is adaptative, it will start with a 3 question active pool.
  final int _INIT_MAX_INDEX_ADAP = 2;
  // A word usually has 3 questions associated
  final int _INDEX_INCREMENT_STEP = 3;

  // Number of questions prompted before adding another question to the active
  // pool (_QUESTION_NUMBER_PER_STAGE > 0).
  final int _NUMBER_OF_QUESTIONS_PER_STAGE = 5;

  int _curQuestionOfStage = 0;

  late List<Question> _questions;
  late QuizConfiguration _quizConfiguration;

  late int _curIndex;
  late int _curMaxIndex;

  Quiz({
    required QuizConfiguration quizConfiguration,
  }) {
    _questions =
        QuestionParser.createFromConfig(quizConfiguration: quizConfiguration);
    _quizConfiguration = quizConfiguration;
    _curMaxIndex = _questions.length - 1;

    _init();
  }

  void _init() {
    _curIndex = -1;
    if (_quizConfiguration.isAdaptative) {
      _curMaxIndex = _INIT_MAX_INDEX_ADAP;
    }
    if (_quizConfiguration.hasRandomOrder) {
      _questions.shuffle();
    }
  }

  int _getNextIndex() {
    if (_quizConfiguration.hasRandomOrder) {
      return Random().nextInt(_curMaxIndex + 1);
    } else {
      _curIndex = _curMaxIndex == 0 ? 0 : (_curIndex + 1) % (_curMaxIndex + 1);
      return _curIndex;
    }
  }

  Question getNextQuestion() {
    if (_curQuestionOfStage >= _NUMBER_OF_QUESTIONS_PER_STAGE) {
      _curQuestionOfStage = 0;
      if (_curMaxIndex < _questions.length - 1) {
        _curMaxIndex =
            min(_curMaxIndex + _INDEX_INCREMENT_STEP, _questions.length - 1);
      }
    }
    _curQuestionOfStage++;

    return _questions[_getNextIndex()];
  }

  int getTotalActivePool() {
    return _curMaxIndex + 1;
  }

  List<TextSpan> getWordsInfo() {
    List<TextSpan> lines = [];

    Map<Word, int> wordIndexes = {};

    List<Word> wordList = _quizConfiguration.wordList;

    List<int> activeQuestionsOfWord =
        List.generate(wordList.length, (index) => 0);

    List<int> totalQuestionsOfWord =
        List.generate(wordList.length, (index) => 0);

    // Calculate Indexes
    for (int i = 0; i < wordList.length; i++) {
      wordIndexes.putIfAbsent(wordList[i], () => i);
    }

    for (int i = 0; i < _questions.length; i++) {
      Word word = _questions[i].word;
      int wordIndex = wordIndexes[word]!;

      // If in active pool
      if (i <= _curMaxIndex) {
        activeQuestionsOfWord[wordIndex]++;
      }
      totalQuestionsOfWord[wordIndex]++;
    }

    for (int i = 0; i < wordList.length; i++) {
      Color color;
      if (activeQuestionsOfWord[i] <= 0) {
        color = Colors.white38;
      } else if (activeQuestionsOfWord[i] >= totalQuestionsOfWord[i]) {
        color = Colors.white;
      } else {
        color = Colors.white70;
      }

      lines.add(
        TextSpan(
            style: TextStyle(color: color),
            text:
                "- ${wordList[i].getPromptNative()}: ${activeQuestionsOfWord[i]}/${totalQuestionsOfWord[i]}\n"),
      );
    }

    return lines;
  }

  QuizConfiguration get quizConfiguration => _quizConfiguration;
}
