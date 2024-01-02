import '../../pages/consts.dart';
import 'gender.dart';
import 'language.dart';

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

  late Language _language;

  late Chapter _chapter;

  Word(
      {required List<String> native,
      required List<String> translation,
      required Gender gender,
      required Language language,
      required Chapter chapter}) {
    _native = native;
    _translation = translation;
    _gender = gender;
    _language = language;
    _chapter = chapter;
  }

  String getPromptNative() {
    return _native.first;
  }

  Chapter get chapter => _chapter;

  Language get language => _language;

  Gender get gender => _gender;

  List<String> get translation => _translation;

  List<String> get native => _native;

  // Factory constructor for creating a new instance from a map
  factory Word.fromJson(Map<String, dynamic> json) {
    Language language = Language.values
        .firstWhere((e) => e.toString().split('.').last == json['language']);

    printd(json['native']);

    return Word(
      native: List<String>.from(json['native']),
      translation: List<String>.from(json['translation']),
      gender: Gender.values
          .firstWhere((e) => e.toString().split('.').last == json['gender']),
      language: language,
      chapter: getChapter(language, json['chapter']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'native': _native,
      'translation': _translation,
      'gender': _gender.toString().split('.').last,
      'language': _language.toString().split('.').last,
      'chapter': _chapter,
    };
  }
}
