import 'package:flutter/widgets.dart';
import 'package:giv_flutter/util/navigation/navigation.dart';

class BaseState<T extends StatefulWidget> extends State<T> {
  Navigation navigation;

  @override
  Widget build(BuildContext context) {
    navigation = Navigation(context);
    return null;
  }
}