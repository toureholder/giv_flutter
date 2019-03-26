import 'package:flutter/material.dart';

class AndroidTheme extends StatelessWidget {
  final Widget child;

  const AndroidTheme({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(platform: TargetPlatform.android), child: child);
  }
}
