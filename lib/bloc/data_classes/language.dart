enum Language { sr, hu, en }

extension LanguageExtension on Language {
  String get text {
    switch (this) {
      case Language.sr:
        return 'Srpski';
      case Language.hu:
        return 'Magyar';
      default:
        return 'English';
    }
  }

  String get firestoreString {
    switch (this) {
      case Language.sr:
        return 'sr';
      case Language.hu:
        return 'hu';
      default:
        return 'en';
    }
  }

  static Language parse(source) {
    switch (source) {
      case 'sr':
        return Language.sr;
      case 'hu':
        return Language.hu;
      default:
        return Language.en;
    }
  }
}
