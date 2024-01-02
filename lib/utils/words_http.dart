import 'dart:convert';

import 'package:duo_words/utils/word/language.dart';
import 'package:duo_words/utils/word/word.dart';
import 'package:duo_words/utils/word_cache.dart';

import '../pages/consts.dart';

Future<List<Word>> getWordListFromDb(
    Language language, Chapter? chapter) async {
  try {
    String data =
        await readFromLocalCache(getUrlForDB(language, chapter).toString());

    if (data.isEmpty) {
      throw Exception("Could not read from cache.");
    }

    var responseList = jsonDecode(data) as List;

    List<Word> words = responseList.map((stringItem) {
      var jsonItem = jsonDecode(stringItem) as Map<String, dynamic>;
      return Word.fromJson(jsonItem);
    }).toList();

    return words;
  } catch (e) {
    printd(e);
    printd("Could not get word list from DB.");
  }
  return [];
}
