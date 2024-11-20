import 'package:duo_words/utils/word/word.dart';
import 'package:duo_words/utils/word/word_cache.dart';

import '../../pages/consts.dart';

Future<List<Word>> getWordListFromDb(String language, String chapter) async {
  try {
    return await readWordListFromLocalCache(produceCacheKey(language, chapter));
  } catch (e) {
    printd(e);
    printd("Could not get word list from DB.");
  }
  return [];
}
