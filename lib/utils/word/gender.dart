enum Gender {
  M, // Masculine
  F, // Feminine
  C, //
  N, // Neuter
  NA, // Not Applicable
}

abstract class GenderClass {
  static String getString(Gender gender) {
    switch (gender) {
      case Gender.M:
        return "Male";
      case Gender.F:
        return "Female";
      case Gender.C:
        return "Common";
      case Gender.N:
        return "Neuter";
      default:
        return "NA";
    }
  }

  static String getAbreviatedString(Gender gender) {
    switch (gender) {
      case Gender.M:
        return "Masc.";
      case Gender.F:
        return "Fem.";
      case Gender.C:
        return "Com.";
      case Gender.N:
        return "Nt.";
      default:
        return "NA";
    }
  }
}
