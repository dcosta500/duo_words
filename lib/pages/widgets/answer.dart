// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../utils/question/question.dart';
import '../../utils/word/gender.dart';

class TextAnswer extends Answer {
  late GlobalKey<_MyTextFieldState> myKey;

  TextAnswer(
      {super.key, required super.question, required super.answerQuestion}) {
    myKey = GlobalKey<_MyTextFieldState>();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();

    void submitAnswer() {
      String answer = textEditingController.text;

      if (answer.isEmpty) {
        return;
      }

      textEditingController.clear();
      textEditingController.dispose();
      myKey = GlobalKey();

      answerQuestion(question, answer).call();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MyTextField(
          submit: submitAnswer,
          textEditingController: textEditingController,
          key: myKey,
        ),
        SizedBox(height: 50.0),
        ElevatedButton(
          onPressed: submitAnswer,
          child: Text("Done"),
        )
      ],
    );
  }
}

class GenderAnswer extends Answer {
  const GenderAnswer(
      {super.key, required super.question, required super.answerQuestion});

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = Gender.values
        .where((gender) => gender != Gender.NA)
        .map(
          (gender) => Expanded(
            child: ElevatedButton(
              onPressed:
                  answerQuestion(question, GenderClass.getString(gender)),
              child: Text(GenderClass.getString(gender)),
            ),
          ),
        )
        .toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons,
    );
  }
}

abstract class Answer extends StatelessWidget {
  final Question question;
  final Function(Question q, String answer) answerQuestion;

  const Answer(
      {required this.question, required this.answerQuestion, super.key});
}

class MyTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final Function submit;
  const MyTextField(
      {required this.submit, required this.textEditingController, super.key});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.textEditingController;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      /*onChanged: (String newValue) {
        if (kIsWeb && newValue.contains(".")) {
          controller.text = newValue.substring(0, newValue.length - 1);
          widget.submit.call();
        }
      },*/
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Translation',
      ),
    );
  }
}
