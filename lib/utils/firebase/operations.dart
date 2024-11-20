// Upload Chapter
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../word/language.dart';
import '../word/word.dart';

// Get language
Future<Map<String, List<Word>>> getLanguageWords(
    String language, List auth) async {
  String accessToken = auth[0];
  String projectId = auth[1];
  final FIRESTORE_BASE_URL =
      'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

  List<Chapter>? chs = chaptersOfLanguage[language];
  Map<String, List<Word>> wordMap = {};
  for (var ch in chs!) {
    final response = await http.get(
      Uri.parse("$FIRESTORE_BASE_URL/words/german/${ch.name}"),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      var m = List.of(Map.of(data)['documents']);
      for (var jsonWord in m) {
        Word w = Word.fromJson(jsonWord);
        wordMap.putIfAbsent(ch.name, () {
          List<Word> w = [];
          return w;
        });
        wordMap[ch.name]!.add(w);
      }
    } else {
      print(
          'Failed to retrieve document: ${response.statusCode}, ${response.body}');
    }
  }
  return wordMap;
}

Future<List<String>> getLanguageCourses(List auth) async {
  String accessToken = auth[0];
  String projectId = auth[1];
  final FIRESTORE_BASE_URL =
      'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

  final response = await http.get(
    Uri.parse('$FIRESTORE_BASE_URL/languages'),
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    //print(response.body);
  } else {
    print(response.body);
    return [""];
  }

  return List.of(List.of(json.decode(response.body)["documents"])
      .map((e) => e["name"].toString().split("/").last));
}

Future<List<String>> getChapters(List auth) async {
  String accessToken = auth[0];
  String projectId = auth[1];
  final FIRESTORE_BASE_URL =
      'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

  final response = await http.get(
    Uri.parse('$FIRESTORE_BASE_URL/chapters'),
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    //print(response.body);
  } else {
    print(response.body);
    return [""];
  }

  return List.of(json.decode(response.body)["documents"])
      .map((e) => e["name"].toString().split("/").last)
      .toList();
}
