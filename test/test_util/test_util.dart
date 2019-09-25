import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/config/i18n/l10n.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/values/strings.dart';
import 'package:provider/provider.dart';

class TestUtil {
  Widget makeTestableWidget({
    Widget subject,
    List<SingleChildCloneableWidget> dependencies,
    List<NavigatorObserver> navigatorObservers,
  }) =>
      MultiProvider(
        providers: dependencies,
        child: MaterialApp(
          localizationsDelegates: [
            const StringLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: L10n.supportedLocales,
          theme: new ThemeData(
            primaryColor: Colors.blue,
            backgroundColor: Colors.blue,
          ),
          home: Material(child: subject),
          navigatorObservers: navigatorObservers ?? const <NavigatorObserver>[],
        ),
      );

  Finder findInternationalizedText(String localizationKey) {
    final Map<String, String> localizationMap = Strings.map[localizationKey];

    return find.byWidgetPredicate((Widget widget) {
      if (widget is Text) {
        final Text textWidget = widget;
        return (textWidget.data != null)
            ? localizationMap.containsValue(textWidget.data)
            : localizationMap.containsValue(textWidget.textSpan.toPlainText());
      } else if (widget is EditableText) {
        final EditableText editable = widget;
        return localizationMap.containsValue(editable.controller.text);
      }
      return false;
    });
  }

  T getWidgetByKey<T>(String key) =>
      find.byKey(Key(key)).evaluate().single.widget as T;

  T getWidgetByType<T>() =>
      find.byType(T).evaluate().single.widget as T;
}
