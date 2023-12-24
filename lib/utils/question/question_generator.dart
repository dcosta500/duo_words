import 'package:duo_words/utils/question/question.dart';
import 'package:duo_words/utils/word/word.dart';

import '../word/gender.dart';

class QuestionParser {
  static List<Question> genFromBuiltinWordList(List<Word> wordsList) {
    // TODO: This method is temporary until I have done a proper database.
    // Probably MongoDB for a NoSQL solution.
    List<Question> questions = [];

    // Generation Logic (change if needed)
    for (Word w in wordsList) {
      // Native to Translation
      questions.add(Question(
          prompt: w.native, answers: w.translation, isPromptNative: true));

      // Translation to Native
      for (String translation in w.translation) {
        questions.add(Question(
            prompt: translation, answers: [w.native], isPromptNative: false));
      }

      // Gender Question
      if (w.gender != Gender.NA) {
        questions.add(Question.gender(prompt: w.native, gender: w.gender));
      }
    }

    return questions;
  }
}
