import 'package:duo_words/utils/word/word.dart';

class QuizConfiguration {
  late List<Word> wordList;

  final bool isAdaptative;
  final bool hasRandomOrder;

  final bool doOnlyGenderedQuestions;
  final bool doOnlyWrittenQuestions;

  QuizConfiguration({
    required this.wordList,
    this.isAdaptative = false,
    this.hasRandomOrder = false,
    this.doOnlyGenderedQuestions = false,
    this.doOnlyWrittenQuestions = false,
  });

  bool isConfigurationCorrect() {
    bool isCorrect = true;

    if (doOnlyGenderedQuestions && doOnlyWrittenQuestions) {
      isCorrect = false;
    }

    return isCorrect;
  }
}
