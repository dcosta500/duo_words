import 'package:flutter/material.dart';

bool _debugMode = true;
void printd(dynamic message) {
  if (_debugMode) {
    // ignore: avoid_print
    print(message);
  }
}

final APP_BAR = AppBar(
  title: const Text("Duo Words"),
);
