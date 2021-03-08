import 'package:flutter/material.dart';
import 'package:giv_flutter/base/my_material_app.dart';
import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/util/presentation/image_precacher.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class MyApp extends StatefulWidget {
  final List<SingleChildWidget> dependencies;

  const MyApp({
    Key key,
    @required this.dependencies,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<SingleChildWidget> dependencies;

  @override
  void initState() {
    dependencies = widget.dependencies;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    preCacheImages(context, svgAssets: Config.imageCacheSvgAssets);

    return MultiProvider(
      providers: dependencies,
      child: MyMaterialApp(),
    );
  }
}
