import 'package:duo_words/pages/consts.dart';
import 'package:duo_words/utils/question/question.dart';
import 'package:duo_words/utils/quiz_configuration.dart';
import 'package:duo_words/utils/word/word.dart';

import '../word/gender.dart';

class QuestionParser {
  static List<Question> createFromConfig({
    required QuizConfiguration quizConfiguration,
  }) {
    // unpack
    if (!quizConfiguration.isConfigurationCorrect()) {
      printd("Question-Parser: Quiz configuration is not correct.");
      return [];
    }

    List<Word> wordsList = quizConfiguration.wordList;

    bool onlyGender = quizConfiguration.doOnlyGenderedQuestions;
    bool onlyWritten = quizConfiguration.doOnlyWrittenQuestions;

    // Inits
    List<Question> questions = [];

    // Generation Logic (change if needed)
    for (Word word in wordsList) {
      if (onlyWritten && !onlyGender) {
        _createWrittenQuestions(questions, word);
      } else if (!onlyWritten && onlyGender) {
        _createGenderedQuestions(questions, word);
      } else if (!onlyGender && !onlyGender) {
        _createWrittenQuestions(questions, word);
        _createGenderedQuestions(questions, word);
      }
    }

    return questions;
  }

  static void _createWrittenQuestions(List<Question> questions, Word word) {
    // Native to Translation
    questions.add(Question(
        prompt: word.getPromptNative(),
        answers: word.translation,
        isPromptNative: true,
        word: word));

    // Translation to Native
    for (String translation in word.translation) {
      questions.add(Question(
        prompt: translation,
        answers: word.native,
        isPromptNative: false,
        word: word,
      ));
    }
  }

  static void _createGenderedQuestions(List<Question> questions, Word word) {
    if (word.gender != Gender.NA) {
      questions.add(Question.gender(
        prompt: word.getPromptNative(),
        gender: word.gender,
        word: word,
      ));
    }
  }
}
