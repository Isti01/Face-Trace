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
  String get text {
    switch (this) {
      case Interest.sports:
        return "⚽ Sport";
      case Interest.music:
        return "🎵 Zene";
      case Interest.reading:
        return "📚 Olvasás";
      case Interest.writing:
        return "📝 Írás";
      case Interest.arts:
        return "🎨 Művészetek";
      case Interest.dancing:
        return "💃 Tánc";
      case Interest.gardening:
        return "🌱 Kertészkedés";
      case Interest.baking:
        return "🍰 Konyha";
      case Interest.movies:
        return "🎥 Filmek";
      case Interest.travelling:
        return "✈️ Utazás";
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
}
