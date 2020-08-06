import 'package:flutter/material.dart';
import 'package:giv_flutter/values/dimens.dart';

class Spacing {
  static SizedBox vertical(double height) => SizedBox(height: height);
  static SizedBox horizontal(double width) => SizedBox(width: width);
}

class DefaultVerticalSpacing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Spacing.vertical(
      Dimens.default_vertical_margin,
    );
  }
}

class DefaultVerticalSpacingAndAHalf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Spacing.vertical(
      Dimens.default_vertical_margin_and_a_half,
    );
  }
}

class DefaultHorizontalSpacing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Spacing.horizontal(
      Dimens.default_horizontal_margin,
    );
  }
}
