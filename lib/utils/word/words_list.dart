import 'package:duo_words/utils/word/word.dart';

import 'gender.dart';

List<Word> _wordList = [];

void add(
    {required dynamic native,
    required dynamic translation,
    required Gender gender}) {
  List<String> nativeList, translationList;
  if (native is String) {
    nativeList = [native];
  } else if (native is List<String>) {
    nativeList = native;
  } else {
    throw Exception("Error adding word to wordList");
  }

  if (translation is String) {
    translationList = [translation];
  } else if (translation is List<String>) {
    translationList = translation;
  } else {
    throw Exception("Error adding word to wordList");
  }

  _wordList.add(
      Word(native: nativeList, translation: translationList, gender: gender));
}

List<Word> genListForGerman() {
  _wordList = [];

  // S1-U1 - Order in a cafe
  /*add(native: "Kaffee", translation: "Coffee", gender: Gender.M);
  add(native: "Milch", translation: "Milk", gender: Gender.F);
  add(native: "Hallo", translation: "Hello", gender: Gender.NA);
  add(native: "Bitte", translation: "Please", gender: Gender.NA);
  add(native: "Und", translation: "And", gender: Gender.NA);
  add(native: "Brot", translation: "Bread", gender: Gender.N);
  add(native: "Tee", translation: "Tea", gender: Gender.M);
  add(native: "Wein", translation: "Wine", gender: Gender.M);
  add(native: "Danke", translation: "Thank You", gender: Gender.NA);
  add(native: "Wasser", translation: "Water", gender: Gender.N);
  add(native: "Bier", translation: "Beer", gender: Gender.N);
  add(native: "Ja", translation: "Yes", gender: Gender.NA);
  add(native: "Nein", translation: "No", gender: Gender.NA);
  add(native: "Tschüss", translation: "Bye", gender: Gender.NA);
  add(native: "Oder", translation: "Or", gender: Gender.NA);*/

  // S1-U1 - Family
  add(native: "Mutter", translation: "Mother", gender: Gender.F);
  add(native: "Vater", translation: "Father", gender: Gender.M);
  add(native: "Ein", translation: "A", gender: Gender.NA);
  add(native: "Eine", translation: "A", gender: Gender.NA);
  add(native: "Ich", translation: "I", gender: Gender.NA);
  add(native: "Bin", translation: "Am", gender: Gender.NA);
  add(native: ["Mein", "Meine"], translation: "My", gender: Gender.NA);
  /*//add(native: "Meine", translation: "My", gender: Gender.NA);
  addWithList(
      native: "Mann", translation: ["Man", "Husband"], gender: Gender.M);
  add(native: "Bruder", translation: "Brother", gender: Gender.M);
  add(native: "Schwester", translation: "Sister", gender: Gender.F);
  add(native: "Sohn", translation: "Son", gender: Gender.M);
  add(native: "Tochter", translation: "Daughter", gender: Gender.F);
  add(native: "Du", translation: "You", gender: Gender.NA);
  add(native: "Bist", translation: "Are", gender: Gender.NA);
  addWithList(native: "Frau", translation: ["Woman", "Wife"], gender: Gender.F);
  add(native: "Groß", translation: "Tall", gender: Gender.NA);
  add(native: "Nett", translation: "Nice", gender: Gender.NA);
  add(native: "Sehr", translation: "Very", gender: Gender.NA);
  add(native: "Klug", translation: "Smart", gender: Gender.NA);
  add(native: "Ist", translation: "Is", gender: Gender.NA);*/

  return _wordList;
}
