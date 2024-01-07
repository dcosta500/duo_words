import 'package:duo_words/utils/word/language.dart';
import 'package:duo_words/utils/word/word.dart';
import 'package:duo_words/utils/word/word_cache.dart';

import '../../pages/consts.dart';

Future<List<Word>> getWordListFromDb(
    Language language, Chapter? chapter) async {
  try {
    return await readFromLocalCache(getUrlForDB(language, chapter).toString());
  } catch (e) {
    printd(e);
    printd("Could not get word list from DB.");
  }
  return [];
}
