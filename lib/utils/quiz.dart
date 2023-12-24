import 'dart:math';

import 'package:duo_words/utils/question/question.dart';
import 'package:duo_words/utils/question/question_generator.dart';
import 'package:duo_words/utils/quiz_configuration.dart';
import 'package:duo_words/utils/word/word.dart';

class Quiz {
  // If quiz is adaptative, it will start with a 3 question active pool.
  final int _INIT_MAX_INDEX_ADAP = 2;

  // Number of questions prompted before adding another question to the active
  // pool (_QUESTION_NUMBER_PER_STAGE > 0).
  final int _NUMBER_OF_QUESTIONS_PER_STAGE = 3;

  int _curQuestionOfStage = 0;

  late List<Question> _questions;
  late QuizConfiguration _qc;
  late int _curMaxIndex;

  Quiz(
      {required List<Word> wordsList,
      required QuizConfiguration quizConfiguration}) {
    _questions = QuestionParser.genFromBuiltinWordList(wordsList);
    _qc = quizConfiguration;
    _curMaxIndex = _questions.length - 1;

    _init();
  }

  void _init() {
    if (_qc.hasRandomOrder) {
      _questions.shuffle();
    }

    if (_qc.isAdaptative) {
      _curMaxIndex = _INIT_MAX_INDEX_ADAP;
    }
  }

  Question getNextQuestion() {
    if (_curQuestionOfStage >= _NUMBER_OF_QUESTIONS_PER_STAGE) {
      _curQuestionOfStage = 0;
      if (_curMaxIndex < _questions.length - 1) {
        _curMaxIndex++;
      }
    }
    _curQuestionOfStage++;

    int index = Random().nextInt(_curMaxIndex + 1);
    return _questions[index];
  }
}
