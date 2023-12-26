// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:audioplayers/audioplayers.dart';
import 'package:duo_words/pages/widgets/answer.dart';
import 'package:duo_words/utils/question/question.dart';
import 'package:duo_words/utils/quiz_configuration.dart';
import 'package:duo_words/utils/word/words_list.dart';
import 'package:flutter/material.dart';

import '../utils/quiz.dart';
import 'consts.dart';

const String CORRECT_SOUND_PATH = '/sounds/correct_sound.mp3';
const String INCORRECT_SOUND_PATH = '/sounds/incorrect_sound.mp3';
const int STATUS_TEXT_DISPLAY_DURATION_IN_SECONDS = 5;

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
  final AudioPlayer audioPlayer = AudioPlayer();

  late GlobalKey<_StatusWidgetState> statusKey;
  late Question question;
  late Quiz quiz;

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  // If null then answer was correct, if not, answer was wrong and this contains
  // the right answer
  String? failedAnswer;
  bool showStatusText = false;

  _QuizContentState() {
    quiz = Quiz(
        wordsList: genListForGerman(), quizConfiguration: QuizConfiguration());
    question = quiz.getNextQuestion();
    statusKey = GlobalKey<_StatusWidgetState>();
  }

  String getHelperText() {
    if (question.isGenderQuestion) {
      return "What's this word's gender?";
    } else {
      return "Translate to ${question.isPromptNative ? "English" : "German"}";
    }
  }

  void playSound() async {
    try {
      await audioPlayer.play(
          AssetSource(
              failedAnswer == null ? CORRECT_SOUND_PATH : INCORRECT_SOUND_PATH),
          mode: PlayerMode.lowLatency);
    } catch (e) {
      print("Error playing audio.");
    }
  }

  void Function()? answerQuestion(Question q, String answer) {
    return () {
      print("Answering question '${q.prompt}' with answer $answer.");

      question = quiz.getNextQuestion();
      showStatusText = true;

      failedAnswer = q.isAnswerCorrect(answer) ? null : q.getAnswers();
      playSound();

      statusKey = GlobalKey<_StatusWidgetState>();

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
        Expanded(
          flex: 1,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  question.prompt,
                  style: TextStyle(fontSize: 60.0 - question.prompt.length),
                ),
                SizedBox(width: 300.0, child: Divider()),
                showStatusText
                    ? StatusWidget(key: statusKey, rightAnswer: failedAnswer)
                    : Container(),
              ],
            ),
          ),
        ),
        // Answer
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 40.0),
              // Answer
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(getHelperText()),
                    SizedBox(height: 10.0),
                    answerWidget,
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class StatusWidget extends StatefulWidget {
  final String? rightAnswer;
  const StatusWidget({required this.rightAnswer, super.key});

  @override
  State<StatusWidget> createState() => _StatusWidgetState();
}

class _StatusWidgetState extends State<StatusWidget> {
  bool showStatusText = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: STATUS_TEXT_DISPLAY_DURATION_IN_SECONDS),
        () {
      showStatusText = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showStatusText) {
      if (widget.rightAnswer == null) {
        return Text("Correct!", style: TextStyle(color: Colors.green));
      } else {
        return RichText(
          text: TextSpan(
            text: 'Wrong... The right answer was ',
            style: TextStyle(color: Colors.red),
            children: <TextSpan>[
              TextSpan(
                text: '${widget.rightAnswer}',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
              // You can add more TextSpan children if needed
              TextSpan(text: '.'),
            ],
          ),
        );
      }
    } else {
      return Container();
    }
  }
}
