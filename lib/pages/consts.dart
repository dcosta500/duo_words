import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

bool kIsDesktop = Platform.isMacOS || Platform.isLinux || Platform.isWindows;

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

AppBar getAppBar({required List<Widget> actions}) {
  return AppBar(
    title: const Text("Duo Words"),
    centerTitle: true,
    actions: actions,
  );
}
