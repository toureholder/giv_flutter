import 'package:flutter/widgets.dart';

class FormUtil {
  final BuildContext context;

  FormUtil(this.context);

  void passFocus(FocusNode current, FocusNode next) {
    current.unfocus();
    if (next != null) FocusScope.of(context).requestFocus(next);
  }
}
