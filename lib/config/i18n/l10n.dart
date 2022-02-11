import 'dart:ui';

class L10n {
  static const supportedLocales = [
    const Locale('pt', ''),
  ];

  static List<String> get supportedLanguageCodes =>
      supportedLocales.map((locale) => locale.languageCode).toList();
}
