import 'package:flutter/material.dart';

class CustomTypography {
  static TextStyle base = TextStyle(color: Color(0xFF252525));

  static TextStyle headline6 = base.copyWith(
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15);

  static TextStyle subtitle2 = base.copyWith(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1);

  static TextStyle body2 = base.copyWith(
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.25);
}
