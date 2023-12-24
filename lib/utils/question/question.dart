import 'package:duo_words/utils/word/word.dart';

class Question {
  late String _prompt;
  late List<String> _answers;
  late Set<String> _answerSet;
  late bool _isGenderQuestion;

  Question({required String prompt, required List<String> answers}) {
    _prompt = prompt;
    _answers = answers;
    _answerSet = Set.from(_answers);

    _isGenderQuestion = false;
  }

  Question.gender({required String prompt, required Gender gender}) {
    Question(prompt: prompt, answers: [gender.toString()]);
    _isGenderQuestion = true;
  }

  String get prompt => _prompt;

  Iterator<String> get answers => _answers.iterator;

  Set<String> get answerSet => Set.from(_answers);

  bool get isGenderQuestion => _isGenderQuestion;

  bool isMultipleChoiceQuestion() {
    return _answerSet.length > 1;
  }

  bool isAnswerCorrect(String answer) {
    return _answerSet.contains(answer);
  }
}
