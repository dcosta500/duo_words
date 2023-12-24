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
  AudioPlayer audioPlayer = AudioPlayer();

  late GlobalKey<_StatusWidgetState> statusKey;
  late Question question;
  late Quiz quiz;

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  bool wasLastQuestionRight = false;
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
      await audioPlayer.play(AssetSource(
          wasLastQuestionRight ? CORRECT_SOUND_PATH : INCORRECT_SOUND_PATH));
    } catch (e) {
      print("Error playing audio.");
    }
  }

  void Function()? answerQuestion(Question q, String answer) {
    return () {
      print("Answering question '${q.prompt}' with answer $answer.");

      question = quiz.getNextQuestion();
      showStatusText = true;

      wasLastQuestionRight = q.isAnswerCorrect(answer);
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
                    ? StatusWidget(
                        key: statusKey, isRight: wasLastQuestionRight)
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
  final bool isRight;
  const StatusWidget({required this.isRight, super.key});

  @override
  State<StatusWidget> createState() => _StatusWidgetState();
}

class _StatusWidgetState extends State<StatusWidget> {
  bool showStatusText = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      showStatusText = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showStatusText) {
      if (widget.isRight) {
        return Text("Correct!", style: TextStyle(color: Colors.green));
      } else {
        return Text("Wrong...", style: TextStyle(color: Colors.red));
      }
    } else {
      return Container();
    }
  }
}
