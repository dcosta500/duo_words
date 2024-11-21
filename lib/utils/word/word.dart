import 'dart:convert';

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

  late String _language;

  late Chapter _chapter;

  Word(
      {required List<String> native,
      required List<String> translation,
      required Gender gender,
      required String language,
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

  String get language => _language;

  Gender get gender => _gender;

  List<String> get translation => _translation;

  List<String> get native => _native;

  // Factory constructor for creating a new instance from a map
  factory Word.fromJson(Map<String, dynamic> json) {
    List<String> native = [];
    if (json["native"].runtimeType == String) {
      native = (jsonDecode(json["native"]) as List)
          .map((e) => e.toString())
          .toList();
    } else {
      native =
          List.of(json["native"] as List).map((e) => e.toString()).toList();
    }

    List<String> translation = [];
    if (json["translation"].runtimeType == String) {
      translation = (jsonDecode(json["translation"]) as List)
          .map((e) => e.toString())
          .toList();
    } else {
      translation = List.of(json["translation"] as List)
          .map((e) => e.toString())
          .toList();
    }

    Gender gender = Gender.values.firstWhere((g) => g.name == json["gender"]);
    String language = json["language"];
    Chapter chapter = Chapter(json["chapter"], json["language"]);

    return Word(
      native: native,
      translation: translation,
      gender: gender,
      language: language,
      chapter: chapter,
    );
  }

  // Convert Word instance to a Map
  Map<String, dynamic> toJson() {
    return {
      "native": jsonEncode(_native),
      "translation": jsonEncode(_translation),
      "gender": _gender.name,
      "language": _language,
      "chapter": _chapter.name,
    };
  }

  @override
  String toString() {
    return "Word -> native: $_native; translation: $translation; gender: ${gender.name}; language: ${language}; chapter: ${chapter.name}";
  }
}
