Map<String, List<Chapter>> chaptersOfLanguage = {};

class Chapter {
  late String _name;
  late String _lang;

  Chapter(String name, String lang) {
    _name = name;
    _lang = lang;
  }

  String get name => _name;
  String get lang => _lang;

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(json["name"], json["lang"]);
  }

  // Convert Word instance to a Map
  Map<String, dynamic> toJson() {
    return {"name": _name, "lang": _lang};
  }
}

String getPresentationString(String chapter) {
  List<String> parts = chapter.split("-");

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
