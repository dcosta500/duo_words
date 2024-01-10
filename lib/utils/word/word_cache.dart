import 'dart:convert';
import 'dart:io';

import 'package:duo_words/pages/consts.dart';
import 'package:duo_words/utils/word/language.dart';
import 'package:duo_words/utils/word/word.dart';
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
Future<List<Word>> readFromLocalCache(String url) async {
  return kIsWeb
      ? await _readFromLocalCacheWeb(url)
      : await _readFromLocalCacheMobile(url);
}

Future<List<Word>> _readFromLocalCacheWeb(String url) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.getString(url)!;

    List jsonList = json.decode(jsonString);

    List<Word> words =
        List.unmodifiable(jsonList.map((e) => Word.fromJson(e)).toList());

    return words;
  } catch (e) {
    printd('Error reading from local web file: $e');
  }
  return [];
}

Future<List<Word>> _readFromLocalCacheMobile(String url) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$CACHE_FILE_NAME');
    if (await file.exists()) {
      final jsonString = await file.readAsString();
      final cacheList = json.decode(jsonString) as Map<String, dynamic>;

      List<Word> words = List.unmodifiable(
        (cacheList[url] as List)
            .map((stringItem) => Word.fromJson(stringItem))
            .toList(),
      );

      return words;
    }
  } catch (e) {
    printd('Error reading from local file: $e');
  }
  return [];
}

// ===== WRITE =====
Future<void> writeToLocalCache(String url, List<Word> words) async {
  //printd("Url (key): $url");
  return kIsWeb
      ? await _writeToLocalCacheWeb(url, words)
      : await _writeToLocalCacheMobileAndMac(url, words);
}

Future<void> _writeToLocalCacheWeb(String url, List<Word> words) async {
  try {
    //printd("Write-Web");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(url, json.encode(words));
  } catch (e) {
    printd("Could not write to local cache: $e");
  }
}

Future<void> _writeToLocalCacheMobileAndMac(
    String url, List<Word> words) async {
  try {
    //printd("Write-Mobile");
    final directory = await getApplicationDocumentsDirectory();

    //printd("Opening directory $directory");
    final file = File('${directory.path}/$CACHE_FILE_NAME');

    Map<String, dynamic> cacheMap = {};

    // Read existing cache, if available
    if (await file.exists()) {
      String existingCache = await file.readAsString();
      //printd("Existing content: $existingCache");
      cacheMap = json.decode(existingCache);
    }

    // Update cache with new data
    cacheMap[url] = words;

    // Save updated cache
    await file.writeAsString(json.encode(cacheMap), flush: true);
  } catch (e) {
    printd(e);
    printd("Could not write to cache, mobile.");
    throw Exception("Could not write to cache, mobile.");
  }
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

    // bytes to utf8
    String data = utf8.decode(response.bodyBytes);

    //printd("Data: $data");

    List<dynamic> jsonData = json.decode(data);

    printd("Grouping...");
    Map<String, List<Word>> groupedByChapter = {};
    for (var item in jsonData) {
      Word word = Word.fromJson(json.decode(item));

      String chapter = word.chapter.name;

      if (!groupedByChapter.containsKey(chapter)) {
        groupedByChapter[chapter] = [];
      }

      // "item" cannot be used here directly, for some reason
      groupedByChapter[chapter]?.add(word);
    }

    printd("Writing...");

    Future.forEach(groupedByChapter.entries,
        (MapEntry<String, List<Word>> entry) async {
      String chapterString = entry.key;
      List<Word> words = entry.value;

      // word is already a json object
      Chapter chapter = getChapter(language, chapterString);

      String url = getUrlForDB(language, chapter).toString();

      await writeToLocalCache(url, words);
    });
  } catch (e) {
    printd(e);
    printd("Could not update local cache.");
    throw Exception("Could not update local cache.");
  }
}
