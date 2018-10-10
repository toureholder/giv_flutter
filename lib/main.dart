import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:giv_flutter/features/base/base.dart';

void main() {
  debugPaintSizeEnabled = false;
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: new Base(),
    );
  }
}
