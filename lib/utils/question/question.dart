import 'package:duo_words/utils/word/word.dart';

import '../word/gender.dart';

class Question {
  late Word _word;

  late String _prompt;
  late bool _isGenderQuestion;
  late bool _isPromptNative;

  // All in lower case
  late List<String> _answers;
  late Set<String> _answerSet;

  Question(
      {required String prompt,
      required List<String> answers,
      required bool isPromptNative,
      required Word word}) {
    _prompt = prompt;
    _isPromptNative = isPromptNative;
    _answers = [];
    _answerSet = Set();
    _word = word;

    for (String answer in answers) {
      _answers.add(answer.toLowerCase());
      _answerSet.add(answer.toLowerCase());
    }

    _isGenderQuestion = false;
  }

  Question.gender(
      {required String prompt, required Gender gender, required Word word}) {
    _prompt = prompt;
    _answers = [];
    _answerSet = Set();
    _word = word;

    _answers.add(GenderClass.getString(gender).toLowerCase());
    _answerSet.add(GenderClass.getString(gender).toLowerCase());

    _isGenderQuestion = true;
    _isPromptNative = true;
  }

  String get prompt => _prompt;

  Iterator<String> get answers => _answers.iterator;

  Set<String> get answerSet => Set.from(_answers);

  bool get isGenderQuestion => _isGenderQuestion;

  bool get isPromptNative => _isPromptNative;

  Word get word => _word;

  bool isAnswerCorrect(String answer) {
    return _answerSet.contains(answer.toLowerCase());
  }

  String getAnswers() {
    String s = "";
    for (String answer in _answers) {
      s += "$answer/";
    }

    // Remove the last character before returning
    if (s.isNotEmpty) {
      s = s.substring(0, s.length - 1);
    }

    return s;
  }
}
