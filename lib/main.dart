import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:giv_flutter/base/app.dart';
import 'package:giv_flutter/base/app_dependencies.dart';

void main() async {
  debugPaintSizeEnabled = false;

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  final dependencies = await getAppDependencies();

  runApp(new MyApp(dependencies: dependencies));
}
