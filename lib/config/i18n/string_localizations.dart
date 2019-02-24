import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:giv_flutter/config/i18n/l10n.dart';
import 'package:giv_flutter/values/strings.dart';

class StringLocalizations {
  StringLocalizations(this.locale);

  final Locale locale;
  final String defaultLanguageCode = L10n.supportedLanguageCodes.first;

  static StringLocalizations of(BuildContext context) {
    return Localizations.of<StringLocalizations>(context, StringLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = Strings.map;

  static const formatItemSymbol = '%1s';

  String get(String key,
      {String formatArg, String formatArg2, String formatArg3}) {
    var localizedString = _getLocalizedValue(key);

    return localizedString
        .replaceFirst(formatItemSymbol, formatArg ?? '')
        .replaceFirst(formatItemSymbol, formatArg2 ?? '')
        .replaceFirst(formatItemSymbol, formatArg3 ?? '');
  }

  String _getLocalizedValue(key) {
    return _localizedValues[key][locale.languageCode] ??
        _localizedValues[key][defaultLanguageCode] ??
        key;
  }
}

class StringLocalizationsDelegate
    extends LocalizationsDelegate<StringLocalizations> {
  const StringLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      L10n.supportedLanguageCodes.contains(locale.languageCode);

  @override
  Future<StringLocalizations> load(Locale locale) {
    return SynchronousFuture<StringLocalizations>(StringLocalizations(locale));
  }

  @override
  bool shouldReload(StringLocalizationsDelegate old) => false;
}

class GetLocalizedStringFunction {
  final BuildContext context;

  GetLocalizedStringFunction(this.context);

  String call(String key,
          {String formatArg, String formatArg2, String formatArg3}) =>
      StringLocalizations.of(context).get(key,
          formatArg: formatArg, formatArg2: formatArg2, formatArg3: formatArg3);
}
