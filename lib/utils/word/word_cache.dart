import 'dart:convert';
import 'dart:io';

import 'package:duo_words/pages/consts.dart';
import 'package:duo_words/utils/firebase/operations.dart';
import 'package:duo_words/utils/word/language.dart';
import 'package:duo_words/utils/word/word.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String CACHE_FILE_NAME = "cached_db_responses";

const String CHAPTERS_OF_LANGUAGE_CACHENAME = "chapters_of_language";

String produceCacheKey(String language, String chapter) {
  return "${language}_$chapter";
}

// ===== READ =====
Future<List<Word>> readWordListFromLocalCache(
    String language, String chapter) async {
  return kIsWeb
      ? await _readWordListFromLocalCacheWeb(produceCacheKey(language, chapter))
      : await _readWordListFromLocalCacheMobile(
          produceCacheKey(language, chapter));
}

Future<List<Word>> _readWordListFromLocalCacheWeb(String cacheKey) async {
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

Future<List<Word>> _readWordListFromLocalCacheMobile(String cacheKey) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$CACHE_FILE_NAME');
    if (await file.exists()) {
      final jsonString = await file.readAsString();
      final cacheList = json.decode(jsonString) as Map<String, dynamic>;

      //printd(cacheList[cacheKey] as List);

      List<Word> words = List.unmodifiable(
        (cacheList[cacheKey] as List)
            .map((stringItem) => Word.fromJson(stringItem))
            .toList(),
      );

      printd(words[0]);

      return words;
    }
  } catch (e) {
    printd('Error reading from local file: $e');
  }
  return [];
}

Future<void> readChaptersOfLanguageFromLocalCache() async {
  return kIsWeb
      ? await _readChaptersOfLanguageFromLocalCacheWeb()
      : await _readChaptersOfLanguageFromLocalCacheMobile();
}

Future<void> _readChaptersOfLanguageFromLocalCacheWeb() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.getString(CHAPTERS_OF_LANGUAGE_CACHENAME)!;
    chaptersOfLanguage = json.decode(jsonString);
  } catch (e) {
    printd('Error reading from local web file: $e');
  }
}

Future<void> _readChaptersOfLanguageFromLocalCacheMobile() async {
  try {
    printd("Reading Chapters of Language");
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$CACHE_FILE_NAME');
    if (await file.exists()) {
      final jsonString = await file.readAsString();
      Map<String, dynamic> cacheList =
          json.decode(json.decode(jsonString)[CHAPTERS_OF_LANGUAGE_CACHENAME]);

      chaptersOfLanguage = cacheList.map((key, value) {
        printd("Value: ${List.of(value)}");
        return MapEntry(
            key, List.of(value).map((e) => Chapter.fromJson(e)).toList());
      });
    }
  } catch (e) {
    printd('Error reading from local file: $e');
  }
}

// ===== WRITE =====
Future<void> writeWordListToLocalCache(
    String cacheKey, List<Word> words) async {
  //printd("Url (key): $url");
  return kIsWeb
      ? await _writeWordListToLocalCacheWeb(cacheKey, words)
      : await _writeWordListToLocalCacheMobileAndMac(cacheKey, words);
}

Future<void> _writeWordListToLocalCacheWeb(
    String cacheKey, List<Word> words) async {
  try {
    //printd("Write-Web");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(cacheKey, json.encode(words));
  } catch (e) {
    printd("Could not write to local cache: $e");
  }
}

Future<void> _writeWordListToLocalCacheMobileAndMac(
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

Future<void> writeChaptersOfLanguageToLocalCache() async {
  //printd("Url (key): $url");
  return kIsWeb
      ? await _writeChaptersOfLanguageToLocalCacheWeb()
      : await _writeChaptersOfLanguageToLocalCacheMobileAndMac();
}

Future<void> _writeChaptersOfLanguageToLocalCacheWeb() async {
  try {
    //printd("Write-Web");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        CHAPTERS_OF_LANGUAGE_CACHENAME, json.encode(chaptersOfLanguage));
  } catch (e) {
    printd("Could not write to local cache: $e");
  }
}

Future<void> _writeChaptersOfLanguageToLocalCacheMobileAndMac() async {
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

    // Save chapters of language
    cacheMap[CHAPTERS_OF_LANGUAGE_CACHENAME] = jsonEncode(chaptersOfLanguage);

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
/// Updates everything.
Future<void> updateLocalLanguageCache() async {
  try {
    chaptersOfLanguage = {};
    List<String> languages = await getLanguageCourses();
    List<String> chapters = await getChapters();

    for (String ch in chapters) {
      String lang = ch.split("_")[0];
      String chap = ch.split("_").skip(1).join("_");

      chaptersOfLanguage.putIfAbsent(lang, () {
        List<Chapter> c = [];
        return c;
      });
      chaptersOfLanguage[lang]!.add(Chapter(chap, lang));
    }
    await writeChaptersOfLanguageToLocalCache();

    for (String l in languages) {
      Map<String, List<Word>> wordsByChapter = await getLanguageWords(l);

      printd("Writing...");

      Future.forEach(wordsByChapter.entries,
          (MapEntry<String, List<Word>> entry) async {
        String chapterString = entry.key;
        List<Word> words = entry.value;

        // word is already a json object
        Chapter chapter =
            chaptersOfLanguage[l]!.firstWhere((ch) => ch.name == chapterString);

        String cacheKey = produceCacheKey(l, chapter.name);

        await writeWordListToLocalCache(cacheKey, words);
      });
    }
  } catch (e) {
    chaptersOfLanguage = {};
    printd(e);
    printd("Could not update local cache.");
    rethrow;
  }
}
