// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:audioplayers/audioplayers.dart';
import 'package:duo_words/pages/widgets/answer.dart';
import 'package:duo_words/utils/question/question.dart';
import 'package:duo_words/utils/quiz_configuration.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/quiz.dart';
import 'consts.dart';

const String CORRECT_SOUND_PATH = '/sounds/correct_sound.mp3';
const String INCORRECT_SOUND_PATH = '/sounds/incorrect_sound.mp3';
const int STATUS_TEXT_DISPLAY_DURATION_IN_SECONDS = 5;

class QuizPage extends StatelessWidget {
  final List<Question> questionList;
  final QuizConfiguration qc;
  const QuizPage({required this.questionList, required this.qc, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: APP_BAR,
      body: Center(
        child: FractionallySizedBox(
          widthFactor: kIsWeb ? 0.5 : 1.0,
          child: QuizContent(
            questionList: questionList,
            qc: qc,
          ),
        ),
      ),
    );
  }
}

// Content
class QuizContent extends StatefulWidget {
  final List<Question> questionList;
  final QuizConfiguration qc;
  const QuizContent({required this.questionList, required this.qc, super.key});

  @override
  State<QuizContent> createState() => _QuizContentState();
}

class _QuizContentState extends State<QuizContent> {
  final AudioPlayer audioPlayer = AudioPlayer();

  late GlobalKey<_StatusWidgetState> statusKey;
  late Question question;
  late Quiz quiz;

  // If null then answer was correct, if not, answer was wrong and this contains
  // the right answer
  String? failedAnswer;
  bool showStatusText = false;

  // Stats
  int totalAnsweredQuestions = 0;
  int totalCorrectAnswers = 0;

  @override
  void initState() {
    super.initState();
    quiz = Quiz(questions: widget.questionList, quizConfiguration: widget.qc);
    printd("Quiz config\n"
        "\t-isAdaptative: ${widget.qc.isAdaptative}\n"
        "\t-hasRandomOrder: ${widget.qc.hasRandomOrder}\n"
        "\t-onlyGender: ${widget.qc.doOnlyGenderedQuestions}\n"
        "\t-onlyWritten: ${widget.qc.doOnlyWrittenQuestions}");
    question = quiz.getNextQuestion();
    statusKey = GlobalKey<_StatusWidgetState>();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  String getHelperText() {
    if (question.isGenderQuestion) {
      return "What's this word's gender?";
    } else {
      String language = question.word.language.name[0].toUpperCase() +
          question.word.language.name.substring(1);
      return "Translate to ${question.isPromptNative ? "English" : language}";
    }
  }

  void playSound() async {
    try {
      await audioPlayer.play(
          AssetSource(
              failedAnswer == null ? CORRECT_SOUND_PATH : INCORRECT_SOUND_PATH),
          mode: PlayerMode.lowLatency);
    } catch (e) {
      printd("Error playing audio.");
    }
  }

  void Function()? answerQuestion(Question q, String answer) {
    return () {
      totalAnsweredQuestions += 1;
      printd("Answering question '${q.prompt}' with answer $answer.");

      question = quiz.getNextQuestion();
      showStatusText = true;

      bool isRight = q.isAnswerCorrect(answer);

      totalCorrectAnswers += isRight ? 1 : 0;
      failedAnswer = isRight ? null : q.getAnswers();
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
          flex: 2,
          child: Center(
            child: Column(
              children: [
                // Statistics
                Expanded(
                  flex: 1,
                  child: StatisticsWidget(
                    totalAnsweredQuestions: totalAnsweredQuestions,
                    totalCorrectAnswers: totalCorrectAnswers,
                    totalActivePool: quiz.getTotalActivePool(),
                  ),
                ),
                // Prompt
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        question.prompt,
                        style:
                            TextStyle(fontSize: 60.0 - question.prompt.length),
                      ),
                      SizedBox(width: 300.0, child: Divider()),
                      showStatusText
                          ? StatusWidget(
                              key: statusKey, rightAnswer: failedAnswer)
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Answer
        Expanded(
          flex: 3,
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

// Status
class StatusWidget extends StatefulWidget {
  final String? rightAnswer;
  const StatusWidget({required this.rightAnswer, super.key});

  @override
  State<StatusWidget> createState() => _StatusWidgetState();
}

class _StatusWidgetState extends State<StatusWidget> {
  bool showStatusText = true;
  late Future<void> disableStatusText;

  @override
  void initState() {
    super.initState();
    disableStatusText = Future.delayed(
        Duration(seconds: STATUS_TEXT_DISPLAY_DURATION_IN_SECONDS), () {
      setState(() {
        showStatusText = false;
      });
    });
  }

  @override
  void dispose() {
    disableStatusText.ignore();
    super.dispose();
  }

  Widget getContent() {
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 20.0, child: getContent());
  }
}

// Statistics
class StatisticsWidget extends StatelessWidget {
  final int totalAnsweredQuestions;
  final int totalCorrectAnswers;
  final int totalActivePool;

  const StatisticsWidget(
      {required this.totalAnsweredQuestions,
      required this.totalCorrectAnswers,
      required this.totalActivePool,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Total: $totalAnsweredQuestions, "
      "Correct Rate: ${(totalAnsweredQuestions > 0 ? (totalCorrectAnswers / totalAnsweredQuestions) * 100 : 0).toInt()}%\n"
      "Active Pool: $totalActivePool",
    );
  }
}
