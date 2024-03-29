import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/config/i18n/l10n.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/values/strings.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class TestUtil {
  Widget makeTestableWidget({
    Widget subject,
    List<SingleChildWidget> dependencies,
    List<NavigatorObserver> navigatorObservers,
  }) =>
      MultiProvider(
        providers: dependencies,
        child: MaterialApp(
          localizationsDelegates: [
            const StringLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
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

  Finder findDialogByContent(String localizationKey) {
    final dialog = find.byType(AlertDialog);
    final content = findInternationalizedText(localizationKey);
    return find.descendant(of: dialog, matching: content);
  }

  T getWidgetByKey<T>(String key) =>
      find.byKey(Key(key)).evaluate().single.widget as T;

  T getWidgetByType<T>({bool skipOffstage = true}) {
    return find.byType(T, skipOffstage: skipOffstage).evaluate().single.widget
        as T;
  }

  Future<void> closeBottomSheetOrDialog(WidgetTester tester,
      {Type type}) async {
    final finalType = type ?? AppBar;
    await tester.tap(
      find.byType(finalType),
      warnIfMissed: false,
    );
    await tester.pump();
  }
}
