import 'package:flutter/material.dart';
import 'package:giv_flutter/base/my_material_app.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  final List<SingleChildCloneableWidget> dependencies;

  const MyApp({Key key, this.dependencies}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<SingleChildCloneableWidget> dependencies;

  @override
  void initState() {
    dependencies = widget.dependencies;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: dependencies,
        child: MyMaterialApp(),
      );
}
