import 'dart:math';

import 'package:flutter/material.dart';

class CustomColors {
  static Color fontColor = Color(0xFF252525);
  static Color white75op = Color(0xBFFFFFFF);
  static Color logoOrange = Color(0xBFffae3b);
  static Color inActiveForeground = Colors.white.withOpacity(0.8);
  static const Color backgroundColor = Colors.white;
  static const Color errorColor = Colors.red;
  static const Color textLinkColor = Colors.blue;
  static const Color emptyStateTextColor = Colors.grey;
  static const Color appBarTextColor = Colors.black87;
  static Color random() {
    final index = new Random().nextInt(hat.length - 0);
    return hat[index];
  }
}

final hat = <Color>[
  Colors.blue[100],
  Colors.amber[100],
  Colors.green[100],
  Colors.red[100],
  Colors.purple[100],
];
