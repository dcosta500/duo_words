enum Language {
  german,
  dutch,
}

class Chapter {
  late String _name;

  Chapter(String name) {
    _name = name;
  }

  String get name => _name;

  @override
  String toString() => _name;

  String getPresentationString() {
    List<String> parts = _name.split("-");

    // Section
    String sectionCode = parts[0];
    int sectionNumber = int.parse(sectionCode.substring(1, sectionCode.length));
    String section = "Section $sectionNumber";

    // Unit
    String unitCode = parts[1];
    int unitNumber = int.parse(unitCode.substring(1, unitCode.length));
    String unit = "Unit $unitNumber";

    // Name
    String nameCode = parts[2];
    String name = nameCode.replaceAll("_", " ").toLowerCase();
    // Capitalise first letter
    name = name[0].toUpperCase() + name.substring(1);

    return "Section $sectionNumber, Unit $unitNumber, $name";
  }
}

class LanguageChapters {
  late Language _language;
  late List<Chapter> _chapters;

  LanguageChapters(Language language, List<Chapter> chapters) {
    _language = language;
    _chapters = chapters;
  }

  List<Chapter> get chapters => _chapters;

  Language get language => _language;
}

Chapter getChapter(Language language, String chapter) {
  return getChapters(language).firstWhere((c) => c.toString() == chapter);
}

List<Chapter> getChapters(Language language) {
  return languageChapters.firstWhere((lc) => lc.language == language).chapters;
}

// Define a function or a getter to provide the chapters for each language
List<LanguageChapters> get languageChapters => [
      LanguageChapters(Language.german, [
        Chapter("s1-u1-basics_1"),
        Chapter("s1-u1-family_1"),
        Chapter("s1-u2-basics_2"),
        Chapter("s1-u2-greetings_1"),
        // Add more chapters as needed
      ]),
      LanguageChapters(Language.german, []),
    ];
