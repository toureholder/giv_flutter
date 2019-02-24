import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:giv_flutter/config/i18n/l10n.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/splash/splash.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return _buildApp();
  }

  MaterialApp _buildApp() => MaterialApp(
    debugShowCheckedModeBanner: false,
    onGenerateTitle: (BuildContext context) =>
        StringLocalizations.of(context).get('app_name'),
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
    home: new Splash(),
  );
}
