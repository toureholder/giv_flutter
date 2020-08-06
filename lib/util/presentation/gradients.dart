import 'package:flutter/material.dart';

class Gradients {
  static Gradient carouselBottomLeft() => LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        stops: [
          0.1,
          0.75,
        ],
        colors: [
          Color(0x59000000),
          Color(0x00FFFFFF),
        ],
      );

  static Gradient carouselBottomRight() => LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
        stops: [
          0.1,
          0.75,
        ],
        colors: [
          Color(0x59000000),
          Color(0x00FFFFFF),
        ],
      );
}
