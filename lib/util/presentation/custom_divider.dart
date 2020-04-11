import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final Color color;

  const CustomDivider({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) => Divider(
        height: 1.0,
        color: color,
      );
}
