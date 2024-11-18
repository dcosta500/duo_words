import 'dart:convert';
import 'dart:io';

import 'package:duo_words/pages/consts.dart';
import 'package:duo_words/utils/firebase/auth.dart';
import 'package:duo_words/utils/firebase/operations.dart';
import 'package:duo_words/utils/word/language.dart';
import 'package:duo_words/utils/word/word.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String CACHE_FILE_NAME = "cached_db_responses";

String produceCacheKey(String language, String chapter) {
  return "${language}_$chapter";
}

// ===== READ =====
Future<List<Word>> readFromLocalCache(String cacheKey) async {
  return kIsWeb
      ? await _readFromLocalCacheWeb(cacheKey)
      : await _readFromLocalCacheMobile(cacheKey);
}

Future<List<Word>> _readFromLocalCacheWeb(String cacheKey) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.getString(cacheKey)!;

    List jsonList = json.decode(jsonString);

    List<Word> words =
        List.unmodifiable(jsonList.map((e) => Word.fromJson(e)).toList());

    return words;
  } catch (e) {
    printd('Error reading from local web file: $e');
  }
  return [];
}

Future<List<Word>> _readFromLocalCacheMobile(String cacheKey) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$CACHE_FILE_NAME');
    if (await file.exists()) {
      final jsonString = await file.readAsString();
      final cacheList = json.decode(jsonString) as Map<String, dynamic>;

      List<Word> words = List.unmodifiable(
        (cacheList[cacheKey] as List)
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
Future<void> writeToLocalCache(String cacheKey, List<Word> words) async {
  //printd("Url (key): $url");
  return kIsWeb
      ? await _writeToLocalCacheWeb(cacheKey, words)
      : await _writeToLocalCacheMobileAndMac(cacheKey, words);
}

Future<void> _writeToLocalCacheWeb(String cacheKey, List<Word> words) async {
  try {
    //printd("Write-Web");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(cacheKey, json.encode(words));
  } catch (e) {
    printd("Could not write to local cache: $e");
  }
}

Future<void> _writeToLocalCacheMobileAndMac(
    String cacheKey, List<Word> words) async {
  try {
    //printd("Write-Mobile -> $cacheKey");
    final directory = await getApplicationDocumentsDirectory();

    //printd("Opening directory $directory");
    final file = File('${directory.path}/$CACHE_FILE_NAME');

    Map<String, dynamic> cacheMap = {};

    // Read existing cache, if available
    if (await file.exists()) {
      String existingCache = await file.readAsString();
      cacheMap = json.decode(existingCache);
    }

    // Update cache with new data
    cacheMap[cacheKey] = [];
    for (var w in words.map((e) => e.toJson())) {
      (cacheMap[cacheKey] as List<dynamic>).add(w);
    }

    // Save updated cache
    //printd("Saving cache");
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
    Map<String, List<Word>> wordsByChapter =
        await getLanguageWords(language, await get_auth());

    printd("Writing...");

    Future.forEach(wordsByChapter.entries,
        (MapEntry<String, List<Word>> entry) async {
      String chapterString = entry.key;
      List<Word> words = entry.value;

      // word is already a json object
      Chapter chapter = chaptersOfLanguage[language.name]!
          .firstWhere((ch) => ch.name == chapterString);

      String cacheKey = produceCacheKey(language.name, chapter.name);

      await writeToLocalCache(cacheKey, words);
    });
  } catch (e) {
    printd(e);
    printd("Could not update local cache.");
    throw Exception("Could not update local cache.");
  }
}
