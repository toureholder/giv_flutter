import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:giv_flutter/base/app.dart';
import 'package:giv_flutter/base/app_dependencies.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPaintSizeEnabled = false;

  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  await Hive.initFlutter();

  await Firebase.initializeApp();

  final dependencies = await getAppDependencies();

  runApp(
    new MyApp(
      dependencies: dependencies,
    ),
  );
}
