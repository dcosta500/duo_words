import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ),
  );
  return;
}

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
