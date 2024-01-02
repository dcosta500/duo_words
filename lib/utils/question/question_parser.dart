import 'package:duo_words/utils/question/question.dart';
import 'package:duo_words/utils/word/language.dart';
import 'package:duo_words/utils/word/word.dart';

import '../word/gender.dart';
import '../words_http.dart';

class QuestionParser {
  static Future<List<Question>> getFromDb(
      {required Language language, required Chapter chapter}) async {
    List<Question> questions = [];

    List<Word> wordsList = await getWordListFromDb(language, chapter);

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
