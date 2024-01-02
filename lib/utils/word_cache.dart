import 'dart:convert';
import 'dart:io';

import 'package:duo_words/pages/consts.dart';
import 'package:duo_words/utils/word/language.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

const String CACHE_FILE_NAME = "cached_db_responses";

Uri getUrlForDB(Language language, Chapter? chapter) {
  String urlString =
      "http://192.168.0.28:8080/duowords/${language.toString().split(".").last.toLowerCase()}";
  if (chapter != null) {
    List<String> parts = chapter.name.split("-");
    // /section/unit/name
    urlString += "/${parts[0]}/${parts[1]}/${parts[2]}";
  }
  return Uri.parse(urlString);
}

Future<void> _printFile() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$CACHE_FILE_NAME');
    if (await file.exists()) {
      printd(await file.readAsString());
    }
  } catch (e) {
    printd('Error reading from local file: $e');
  }
}

Future<String> readFromLocalCache(String url) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$CACHE_FILE_NAME');
    if (await file.exists()) {
      final jsonString = await file.readAsString();
      final cacheList = jsonDecode(jsonString) as Map<String, dynamic>;
      return jsonEncode(cacheList[url]);
    }
  } catch (e) {
    printd('Error reading from local file: $e');
  }
  return "";
}

Future<void> writeToLocalCache(String url, dynamic data) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$CACHE_FILE_NAME');

  Map<String, dynamic> cacheMap = {};

  // Read existing cache, if available
  if (await file.exists()) {
    String existingCache = await file.readAsString();
    cacheMap = jsonDecode(existingCache);
  }

  // Update cache with new data
  cacheMap[url] = data;

  // Save updated cache
  await file.writeAsString(jsonEncode(cacheMap));
}

Future<void> updateLocalCacheForLanguage(Language language) async {
  try {
    var url = getUrlForDB(language, null);

    printd("Attempting to retrieve word list. URL: $url");
    Response response = await http.get(url);
    printd("Got response back.");

    if (response.statusCode != 200) {
      printd('Request failed with status: ${response.statusCode}.');
    }

    String data = utf8.decode(response.bodyBytes);

    List<dynamic> jsonData = jsonDecode(data);

    printd("Grouping...");
    Map<String, List<dynamic>> groupedByChapter = {};
    for (var item in jsonData) {
      var word = jsonDecode(item);

      String chapter = word['chapter'] as String;

      if (!groupedByChapter.containsKey(chapter)) {
        groupedByChapter[chapter] = [];
      }

      groupedByChapter[chapter]?.add(item);
    }

    printd("Writing...");
    groupedByChapter.forEach((chapterString, words) async {
      Chapter chapter = getChapter(language, chapterString);

      String url = getUrlForDB(language, chapter).toString();
      var data = groupedByChapter[chapterString];

      await writeToLocalCache(url, data);
    });
  } catch (e) {
    printd(e);
    printd("Could not update local cache.");
  }
}
