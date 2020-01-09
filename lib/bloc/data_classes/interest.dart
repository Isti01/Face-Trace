import 'package:face_app/localizations/localizations.dart';
import 'package:flutter/cupertino.dart';

enum Interest {
  sports,
  music,
  reading,
  writing,
  arts,
  dancing,
  gardening,
  baking,
  movies,
  travelling,
}

extension InterestExtension on Interest {
  String text(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    switch (this) {
      case Interest.sports:
        return "⚽ ${localizations.sportsInterest}";
      case Interest.music:
        return "🎵 ${localizations.musicInterest}";
      case Interest.reading:
        return "📚 ${localizations.readingInterest}";
      case Interest.writing:
        return "📝 ${localizations.writingInterest}";
      case Interest.arts:
        return "🎨 ${localizations.artsInterest}";
      case Interest.dancing:
        return "💃 ${localizations.dancingInterest}";
      case Interest.gardening:
        return "🌱 ${localizations.gardeningInterest}";
      case Interest.baking:
        return "🍰 ${localizations.bakingInterest}";
      case Interest.movies:
        return "🎥 ${localizations.moviesInterest}";
      case Interest.travelling:
        return "✈️ ${localizations.travellingInterest}";
      default:
        return "Not implemented";
    }
  }

  static List<Interest> parseList(List source) {
    try {
      return List<String>.from(source)
          .map(parse)
          .where((i) => i != null)
          .toList();
    } catch (e, s) {
      print([e, s]);
      return [];
    }
  }

  static Interest parse(String source) {
    switch (source.toLowerCase()) {
      case 'sports':
        return Interest.sports;
      case 'music':
        return Interest.music;
      case 'reading':
        return Interest.reading;
      case 'writing':
        return Interest.writing;
      case 'arts':
        return Interest.arts;
      case 'dancing':
        return Interest.dancing;
      case 'gardening':
        return Interest.gardening;
      case 'baking':
        return Interest.baking;
      case 'movies':
        return Interest.movies;
      case 'travelling':
        return Interest.travelling;
    }
    return null;
  }

  static String toFirestore(Interest source) {
    switch (source) {
      case Interest.sports:
        return 'sports';
      case Interest.music:
        return 'music';
      case Interest.reading:
        return 'reading';
      case Interest.writing:
        return 'writing';
      case Interest.arts:
        return 'arts';
      case Interest.dancing:
        return 'dancing';
      case Interest.gardening:
        return 'gardening';
      case Interest.baking:
        return 'baking';
      case Interest.movies:
        return 'movies';
      case Interest.travelling:
        return 'travelling';
      default:
        return 'travelling';
    }
  }
}
