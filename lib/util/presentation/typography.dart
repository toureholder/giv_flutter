import 'package:flutter/material.dart';
import 'package:giv_flutter/values/colors.dart';

class CustomTypography {
  static Color baseColor = CustomColors.fontColor;

  static TextStyle base = TextStyle(color: baseColor);

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

  static TextStyle caption = base.copyWith(
      fontSize: 12.0, fontWeight: FontWeight.w400, letterSpacing: 0.4);

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
  final List<Shadow> shadows;
  final TextAlign textAlign;
  final int maxLines;
  final TextOverflow overflow;

  const BaseText(this.data,
      {Key key,
      this.syntheticWeight,
      this.textStyle,
      this.color,
      this.shadows,
      this.textAlign,
      this.maxLines,
      this.overflow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    FontWeight finalFontWeight = textStyle.fontWeight;
    final map = CustomTypography.weightMap;
    if (syntheticWeight != null && map.containsKey(syntheticWeight))
      finalFontWeight = map[syntheticWeight];

    var finalTextStyle = textStyle.copyWith(
      fontWeight: finalFontWeight,
      color: color ?? textStyle.color,
      shadows: shadows,
    );

    return Text(data,
        style: finalTextStyle,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow);
  }
}

class H6Text extends BaseText {
  final String data;
  final SyntheticFontWeight weight;
  final Color color;
  final List<Shadow> shadows;

  H6Text(this.data, {Key key, this.weight, this.color, this.shadows})
      : super(
          data,
          textStyle: CustomTypography.h6,
          syntheticWeight: weight,
          color: color,
          shadows: shadows,
        );
}

class Title extends BaseText {
  final String data;
  final SyntheticFontWeight weight;
  final Color color;
  final List<Shadow> shadows;

  Title(this.data, {Key key, this.weight, this.color, this.shadows})
      : super(
          data,
          textStyle: CustomTypography.title,
          syntheticWeight: weight,
          color: color,
          shadows: shadows,
        );
}

class Subtitle extends BaseText {
  final String data;
  final SyntheticFontWeight weight;
  final Color color;
  final List<Shadow> shadows;

  Subtitle(this.data, {Key key, this.weight, this.color, this.shadows})
      : super(
          data,
          textStyle: CustomTypography.subtitle1,
          syntheticWeight: weight,
          color: color,
          shadows: shadows,
        );
}

class Subtitle2 extends BaseText {
  final String data;
  final SyntheticFontWeight weight;
  final Color color;
  final List<Shadow> shadows;

  Subtitle2(this.data, {Key key, this.weight, this.color, this.shadows})
      : super(
          data,
          textStyle: CustomTypography.subtitle2,
          syntheticWeight: weight,
          color: color,
          shadows: shadows,
        );
}

class BodyText extends BaseText {
  final String data;
  final SyntheticFontWeight weight;
  final Color color;
  final List<Shadow> shadows;
  final TextAlign textAlign;

  BodyText(this.data,
      {Key key, this.weight, this.color, this.shadows, this.textAlign})
      : super(data,
            textStyle: CustomTypography.body,
            syntheticWeight: weight,
            color: color,
            shadows: shadows,
            textAlign: textAlign);
}

class Body2Text extends BaseText {
  final String data;
  final SyntheticFontWeight weight;
  final Color color;
  final List<Shadow> shadows;
  final TextAlign textAlign;
  final int maxLines;
  final TextOverflow overflow;

  Body2Text(this.data,
      {Key key,
      this.weight,
      this.color,
      this.shadows,
      this.textAlign,
      this.maxLines,
      this.overflow})
      : super(data,
            textStyle: CustomTypography.body2,
            syntheticWeight: weight,
            color: color,
            shadows: shadows,
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow);
}

class Caption extends BaseText {
  final String data;
  final SyntheticFontWeight weight;
  final Color color;
  final List<Shadow> shadows;
  final TextAlign textAlign;

  Caption(this.data,
      {Key key, this.weight, this.color, this.shadows, this.textAlign})
      : super(data,
            textStyle: CustomTypography.caption,
            syntheticWeight: weight,
            color: color,
            shadows: shadows,
            textAlign: textAlign);
}
