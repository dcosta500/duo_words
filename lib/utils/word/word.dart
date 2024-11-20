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
    // native, translation, gender, language, chapter

    List<String> native = List.of(
        List.of(json["fields"]["native"]["arrayValue"]["values"])
            .map((e) => e["stringValue"]));

    List<String> translation = List.of(
        List.of(json["fields"]["translation"]["arrayValue"]["values"])
            .map((e) => e["stringValue"]));

    Gender gender = Gender.values.firstWhere(
        (gender) => gender.name == json["fields"]["gender"]["stringValue"]);

    String language = json["fields"]["language"]["stringValue"];

    Chapter chapter = chaptersOfLanguage[language]!.firstWhere(
        (ch) => ch.name == json["fields"]["chapter"]["stringValue"]);

    return Word(
        native: native,
        translation: translation,
        gender: gender,
        language: language,
        chapter: chapter);
  }

  // Convert Word instance to a Map
  Map<String, dynamic> toJson() {
    return {
      "fields": {
        'native': {
          "arrayValue": {
            "values": List.of(_native.map((e) => {"stringValue": e}))
          }
        },
        'translation': {
          "arrayValue": {
            "values": List.of(_translation.map((e) => {"stringValue": e}))
          }
        },
        'gender': {"stringValue": _gender.name},
        'language': {"stringValue": _language},
        'chapter': {"stringValue": _chapter.name},
      }
    };
  }

  @override
  String toString() {
    return "Word -> native: $_native; translation: $translation; gender: ${gender.name}; language: ${language}; chapter: ${chapter.name}";
  }
}
