import 'package:flutter/material.dart';
import 'package:giv_flutter/util/navigation/no_animation_page_route.dart';

class Navigation {
  final BuildContext context;

  Navigation(this.context);

  Future<T> push<T extends Object>(Widget page,
      {bool hasAnimation = true, bool clearStack = false}) {
    var route = hasAnimation ? _pageRoute(page) : _noAnimationPageRoute(page);

    if (clearStack) {
      return Navigator.pushAndRemoveUntil(
          context, route, (Route<dynamic> route) => false);
    } else {
      return Navigator.push(context, route);
    }
  }

  bool pop<T extends Object>([ T result ]) => Navigator.of(context).pop(result);


  void pushReplacement(Widget page, {bool hasAnimation = true}) {
    var route = hasAnimation ? _pageRoute(page) : _noAnimationPageRoute(page);
    Navigator.pushReplacement(context, route);
  }

  Route _pageRoute(Widget page) =>
      MaterialPageRoute(builder: (BuildContext context) => page);

  Route _noAnimationPageRoute(Widget page) =>
      NoAnimationPageRoute(builder: (BuildContext context) => page);
}
