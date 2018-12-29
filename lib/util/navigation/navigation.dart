import 'package:flutter/material.dart';

class Navigation {
  final BuildContext context;

  Navigation(this.context);

  void push(Widget page) {
    Navigator.push(context, _pageRoute(page));
  }

  Route _pageRoute(Widget page) =>
      MaterialPageRoute(builder: (BuildContext context) => page);
}
