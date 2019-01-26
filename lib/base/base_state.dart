import 'package:flutter/widgets.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/base/base.dart';
import 'package:giv_flutter/util/navigation/navigation.dart';

class BaseState<T extends StatefulWidget> extends State<T> {
  Navigation navigation;
  GetLocalizedStringFunction string;

  @override
  Widget build(BuildContext context) {
    navigation = Navigation(context);
    string = GetLocalizedStringFunction(context);
    return null;
  }

  void onLoginSuccess(Widget redirect) {
    if (redirect == null) {
      Navigation(context).push(Base(), clearStack: true);
    } else {
      Navigation(context).pushReplacement(redirect);
    }
  }
}
