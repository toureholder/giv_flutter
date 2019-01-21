import 'package:flutter/widgets.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/util/form/form_util.dart';

class CustomFormFieldState<T extends StatefulWidget> extends BaseState<T> {
  GetLocalizedStringFunction string;
  FocusNode focusNode;
  FormUtil formUtil;

  bool autovalidate = false;

  @override
  void initState() {
    super.initState();
    focusNode = focusNode ?? FocusNode();

    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        setState(() {
          autovalidate = true;
        });
      }
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    formUtil = FormUtil(context);
    return null;
  }
}