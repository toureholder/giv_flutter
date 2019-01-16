import 'package:flutter/material.dart';

class CustomTypography {
  static TextStyle base = TextStyle(color: Color(0xFF252525));

  static TextStyle h6 = base.copyWith(
      fontSize: 20.0, fontWeight: FontWeight.w500, letterSpacing: 0.15);

  static TextStyle title = base.copyWith(
      fontSize: 20.0, fontWeight: FontWeight.w500, letterSpacing: 0.0);

  static TextStyle titleHint = title.copyWith(color: Colors.grey[400]);

  static TextStyle subtitle1 = base.copyWith(
      fontSize: 16.0, fontWeight: FontWeight.w400, letterSpacing: 0.15);

  static TextStyle subtitle2 = base.copyWith(
      fontSize: 14.0, fontWeight: FontWeight.w600, letterSpacing: 0.1);

  static TextStyle body = base.copyWith(
      fontSize: 16.0, fontWeight: FontWeight.w400, letterSpacing: 0.5);

  static TextStyle body2 = base.copyWith(
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.25);

  static Map<SyntheticFontWeight, FontWeight> weightMap = {
    SyntheticFontWeight.semiBold: FontWeight.w600,
    SyntheticFontWeight.bold: FontWeight.w700,
    SyntheticFontWeight.regular: FontWeight.w400,
    SyntheticFontWeight.light: FontWeight.w300,
    SyntheticFontWeight.thin: FontWeight.w100,
  };
}

enum SyntheticFontWeight { semiBold, bold, regular, light, thin }

class BaseText extends StatelessWidget {
  final String data;
  final SyntheticFontWeight syntheticWeight;
  final TextStyle textStyle;
  final Color color;

  const BaseText(this.data, {Key key, this.syntheticWeight, this.textStyle, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    FontWeight finalFontWeight = textStyle.fontWeight;
    final map = CustomTypography.weightMap;
    if (syntheticWeight != null && map.containsKey(syntheticWeight))
      finalFontWeight = map[syntheticWeight];

    var finalTextStyle = textStyle.copyWith(
        fontWeight: finalFontWeight,
        color: color ?? textStyle.color);

    return Text(data, style: finalTextStyle);
  }
}

class H6Text extends BaseText {
  final String data;
  final SyntheticFontWeight weight;
  final Color color;

  H6Text(this.data, {Key key, this.weight, this.color})
      : super(data, textStyle: CustomTypography.h6, syntheticWeight: weight, color: color);
}

class Title extends BaseText {
  final String data;
  final SyntheticFontWeight weight;
  final Color color;

  Title(this.data, {Key key, this.weight, this.color})
      : super(data, textStyle: CustomTypography.title, syntheticWeight: weight, color: color);
}

class Subtitle extends BaseText {
  final String data;
  final SyntheticFontWeight weight;
  final Color color;

  Subtitle(this.data, {Key key, this.weight, this.color})
      : super(data,
            textStyle: CustomTypography.subtitle1, syntheticWeight: weight, color: color);
}

class Subtitle2 extends BaseText {
  final String data;
  final SyntheticFontWeight weight;
  final Color color;

  Subtitle2(this.data, {Key key, this.weight, this.color})
      : super(data,
            textStyle: CustomTypography.subtitle2, syntheticWeight: weight, color: color);
}

class BodyText extends BaseText {
  final String data;
  final SyntheticFontWeight weight;
  final Color color;

  BodyText(this.data, {Key key, this.weight, this.color})
      : super(data, textStyle: CustomTypography.body, syntheticWeight: weight, color: color);
}

class Body2Text extends BaseText {
  final String data;
  final SyntheticFontWeight weight;
  final Color color;

  Body2Text(this.data, {Key key, this.weight, this.color})
      : super(data, textStyle: CustomTypography.body2, syntheticWeight: weight, color: color);
}