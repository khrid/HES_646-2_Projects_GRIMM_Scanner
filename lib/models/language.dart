class Language {
  final int id;
  final String name;
  final String languageCode;

  Language(this.id, this.name, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      Language(1, 'English', 'en'),
      Language(2, 'Francais', 'fr'),
      Language(3, 'Deutsch', 'de'),
    ];
  }

  static Language getDefaultLanguage() {
    return languageList()[0];
  }

  static Language getLanguage(String id) {
    switch (id) {
      case 'en':
        return languageList()[0];
      case 'fr':
        return languageList()[1];
       case 'de':
        return languageList()[2];
      default:
        return languageList()[0];
    }
  }
}
