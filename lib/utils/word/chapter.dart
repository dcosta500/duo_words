enum Chapter {
  // German
  S1_U1_ORDER_IN_A_CAFE,
  S1_U1_FAMILY,
}

abstract class ChapterClass {
  static String _getChar(String s, int charIdx) {
    return s.substring(charIdx, charIdx + 1);
  }

  static List<String> _splitChapterParts(String s) {
    List<String> parts = [];

    int curTime = 0;
    String curString = "";
    for (int i = 0; i < s.length; i++) {
      String char = _getChar(s, i);
      if (char == "_") {
        parts.add(curString);
        curTime++;
        curString = "";

        if (curTime >= 2) {
          parts.add(s.substring(i));
          break;
        }
      } else {
        curString += char;
      }
    }

    return parts;
  }

  static String getString(Chapter chapter) {
    List<String> parts = _splitChapterParts(chapter.toString().split(".")[1]);

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
    name = name.substring(0, 1).toUpperCase() + name.substring(1);

    return "Section $sectionNumber, Unit $unitNumber, $name";
  }
}
