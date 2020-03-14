import 'package:flutter/material.dart';
import 'package:giv_flutter/values/dimens.dart';

class Spacing {
  static SizedBox vertical(double height) => SizedBox(height: height);
  static SizedBox horizontal(double width) => SizedBox(width: width);
}

class DefualtVerticalSpacing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Spacing.vertical(
      Dimens.default_vertical_margin,
    );
  }
}
