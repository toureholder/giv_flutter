import 'package:flutter/material.dart';

class Themes {
  static Theme ofPrimaryBlue(Widget child) {
    return Theme(
      data: ThemeData(primarySwatch: Colors.blue),
      child: child,
    );
  }
}
