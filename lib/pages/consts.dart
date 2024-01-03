import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void printd(dynamic message) {
  if (!kReleaseMode) {
    // ignore: avoid_print
    print(message);
  }
}

final APP_BAR = AppBar(
  title: const Text("Duo Words"),
  centerTitle: true,
);
