// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:duo_words/pages/widgets/answer.dart';
import 'package:duo_words/utils/question/question.dart';
import 'package:duo_words/utils/quiz_configuration.dart';
import 'package:duo_words/utils/word/words_list.dart';
import 'package:flutter/material.dart';

import '../utils/quiz.dart';
import 'consts.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: APP_BAR,
      body: Center(
        child: QuizContent(),
      ),
    );
  }
}

class QuizContent extends StatefulWidget {
  const QuizContent({super.key});

  @override
  State<QuizContent> createState() => _QuizContentState();
}

class _QuizContentState extends State<QuizContent> {
  late Question question;
  late Quiz quiz;

  _QuizContentState() {
    quiz = Quiz(
        wordsList: genListForGerman(), quizConfiguration: QuizConfiguration());
    question = quiz.getNextQuestion();
  }

  void Function()? answerQuestion(Question q, String answer) {
    return () {
      print("Answering question '${q.prompt}' with answer $answer.");
      if (q.isAnswerCorrect(answer)) {
        print("Answer is correct!");
      } else {
        print("Answer is incorrect.");
      }

      question = quiz.getNextQuestion();

      setState(() {});
    };
  }

  @override
  Widget build(BuildContext context) {
    Answer answerWidget = question.isGenderQuestion
        ? GenderAnswer(
            question: question,
            answerQuestion: answerQuestion,
          )
        : TextAnswer(
            question: question,
            answerQuestion: answerQuestion,
          );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Prompt
        Text(
          question.prompt,
          style: TextStyle(fontSize: 40.0),
        ),
        // Answer
        answerWidget,
      ],
    );
  }
}
