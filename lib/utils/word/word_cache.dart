import 'dart:convert';
import 'dart:io';

import 'package:duo_words/pages/consts.dart';
import 'package:duo_words/utils/word/language.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

// ===== READ =====
Future<String> readFromLocalCache(String url) async {
  return kIsWeb
      ? await _readFromLocalCacheWeb(url)
      : await _readFromLocalCacheMobile(url);
}

Future<String> _readFromLocalCacheWeb(String url) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(url)!;
  } catch (e) {
    printd('Error reading from local file: $e');
  }
  return "";
}

Future<String> _readFromLocalCacheMobile(String url) async {
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

// ===== WRITE =====
Future<void> writeToLocalCache(String url, dynamic data) async {
  return kIsWeb
      ? await _writeToLocalCacheWeb(url, data)
      : await _writeToLocalCacheMobile(url, data);
}

Future<void> _writeToLocalCacheWeb(String url, dynamic data) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    printd("Url (key): $url");
    await prefs.setString(url, jsonEncode(data));
  } catch (e) {
    printd("Could not write to local cache: $e");
  }
}

Future<void> _writeToLocalCacheMobile(String url, dynamic data) async {
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

// ===== UPDATE =====
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
      // word is already a json object
      Chapter chapter = getChapter(language, chapterString);

      String url = getUrlForDB(language, chapter).toString();

      await writeToLocalCache(url, words);
    });
  } catch (e) {
    printd(e);
    printd("Could not update local cache.");
  }
}
