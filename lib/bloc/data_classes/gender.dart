enum Gender {
  female,
  male,
  other,
}

extension GenderExtension on Gender {
  String get text {
    switch (this) {
      case Gender.female:
        return "Nő 👩";
      case Gender.male:
        return "Férfi 👨";
      default:
        return "Egyéb 🧑";
    }
  }

  static parse(String source) {
    switch (source.toLowerCase()) {
      case "female":
        return Gender.female;
      case "male":
        return Gender.male;
      default:
        return Gender.other;
    }
  }
}
