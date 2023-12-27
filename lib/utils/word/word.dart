import 'gender.dart';

class Word {
  // List of native words. A word can have multiple forms
  // For instance, ein and eine in german.
  late List<String> _native;

  // A word can have multiple translations
  // For instance, mann can be man or husband, in german, depending on the
  // context.
  late List<String> _translation;

  // Depending on the language, a word can have a gender.
  late Gender _gender;

  Word(
      {required List<String> native,
      required List<String> translation,
      required Gender gender}) {
    _native = native;
    _translation = translation;
    _gender = gender;
  }

  List<String> get translation => _translation;

  List<String> get nativeList => _native;

  // Only the first will be used as a prompt, but the player can
  // answer with any of the native (or any of the translations, depending
  // on the question)
  String get native => _native[0];

  Gender get gender => _gender;
}
