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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MyTextField(key: myKey, textEditingController: textEditingController),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              String answer = textEditingController.text;
              textEditingController.clear();
              textEditingController.dispose();
              myKey = GlobalKey();
              answerQuestion(question, answer).call();
            },
            child: Text("Done"),
          )
        ],
      ),
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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons,
      ),
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
  const MyTextField({super.key, required this.textEditingController});

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
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Translation',
      ),
    );
  }
}
