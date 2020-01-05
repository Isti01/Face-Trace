enum Gender {
  female,
  male,
  other,
}

extension GenderExtension on Gender {
  String get text {
    switch (this) {
      case Gender.female:
        return "Nő $emoji";
      case Gender.male:
        return "Férfi $emoji";
      default:
        return "Egyéb $emoji";
    }
  }

  String get emoji {
    switch (this) {
      case Gender.female:
        return "👩";
      case Gender.male:
        return "👨";
      default:
        return "🧑";
    }
  }

  static Gender parse(String source) {
    switch (source.toLowerCase()) {
      case "female":
        return Gender.female;
      case "male":
        return Gender.male;
      default:
        return Gender.other;
    }
  }

  static List<Gender> parseList(map) {
    if (map == null) return [];

    try {
      return List<String>.from(map).map(parse).toList();
    } catch (e, s) {
      print([e, s]);
      return [];
    }
  }
}
