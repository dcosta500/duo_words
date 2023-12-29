import 'package:duo_words/utils/question/question.dart';
import 'package:duo_words/utils/word/chapter.dart';
import 'package:duo_words/utils/word/language.dart';
import 'package:duo_words/utils/word/word.dart';

import '../word/gender.dart';

class QuestionParser {
  static Future<List<Word>> _getWordListFromDb(
      Language language, Chapter chapter) async {
    return [];
  }

  static Future<List<Question>> getFromDb(
      {required Language language, required Chapter chapter}) async {
    List<Question> questions = [];

    List<Word> wordsList = await _getWordListFromDb(language, chapter);

    // Generation Logic (change if needed)
    for (Word w in wordsList) {
      // Native to Translation
      questions.add(Question(
          prompt: w.getPromptNative(),
          answers: w.translation,
          isPromptNative: true));

      // Translation to Native
      for (String translation in w.translation) {
        questions.add(Question(
            prompt: translation, answers: w.native, isPromptNative: false));
      }

      // Gender Question
      if (w.gender != Gender.NA) {
        questions.add(
            Question.gender(prompt: w.getPromptNative(), gender: w.gender));
      }
    }

    return questions;
  }
}
