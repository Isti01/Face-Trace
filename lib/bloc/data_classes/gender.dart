import 'package:face_app/localizations/localizations.dart';
import 'package:flutter/cupertino.dart';

enum Gender {
  female,
  male,
  other,
}

extension GenderExtension on Gender {
  String text(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    switch (this) {
      case Gender.female:
        return "${localizations.femaleGender} $emoji";
      case Gender.male:
        return "${localizations.maleGender} $emoji";
      default:
        return "${localizations.otherGender} $emoji";
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
