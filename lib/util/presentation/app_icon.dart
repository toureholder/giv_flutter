import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIcon extends StatelessWidget {
  final double width;
  final double height;

  const AppIcon({Key key, this.width = 64.0, this.height = 64.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'images/logo.svg',
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }
}
