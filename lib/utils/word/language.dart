Map<String, List<Chapter>> get chaptersOfLanguage => {
      Language.german.name: [
        Chapter("s1-u1-basics_1", Language.german),
        Chapter("s1-u1-family_1", Language.german),
        Chapter("s1-u2-basics_2", Language.german),
        Chapter("s1-u2-greetings_1", Language.german),
        Chapter("s1-u3-restaurant_1", Language.german),
        Chapter("s1-u3-places_1", Language.german),
      ],
      Language.dutch.name: [],
    };

enum Language {
  german,
  dutch,
}

class Chapter {
  late String _name;
  late Language _lang;

  Chapter(String name, Language lang) {
    _name = name;
    _lang = lang;
  }

  String get name => _name;
  Language get lang => _lang;

  @override
  String toString() => _name;

  String getPresentationString() {
    List<String> parts = _name.split("-");

    // Section
    String sectionCode = parts[0];
    int sectionNumber = int.parse(sectionCode.substring(1, sectionCode.length));
    //String section = "Section $sectionNumber";

    // Unit
    String unitCode = parts[1];
    int unitNumber = int.parse(unitCode.substring(1, unitCode.length));
    //String unit = "Unit $unitNumber";

    // Name
    String nameCode = parts[2];
    String name = nameCode.replaceAll("_", " ").toLowerCase();
    // Capitalise first letter
    name = name[0].toUpperCase() + name.substring(1);

    return "Section $sectionNumber, Unit $unitNumber, $name";
  }
}
