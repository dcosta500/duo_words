import 'package:duo_words/utils/question/question.dart';
import 'package:duo_words/utils/question/question_generator.dart';
import 'package:duo_words/utils/quiz_configuration.dart';
import 'package:duo_words/utils/word/word.dart';

class Quiz {
  late List<Question> _questions;
  late QuizConfiguration _qc;

  Quiz(
      {required List<Word> wordsList,
      required QuizConfiguration quizConfiguration}) {
    _questions = QuestionParser.genFromBuiltinWordList(wordsList);
    _qc = quizConfiguration;
  }
}
