import 'package:flutter/material.dart';
import 'package:giv_flutter/values/colors.dart';

class AndroidTheme extends StatelessWidget {
  final Widget child;
  final Color primaryColor;

  const AndroidTheme({
    Key key,
    @required this.child,
    this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        platform: TargetPlatform.android,
        primaryColor: primaryColor ?? Colors.blue,
        backgroundColor: Colors.blue,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: CustomColors.accentColor,
        ),
      ),
      child: child,
    );
  }
}
