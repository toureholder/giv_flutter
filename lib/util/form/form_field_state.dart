import 'package:flutter/widgets.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/util/form/form_util.dart';

class CustomFormFieldState<T extends StatefulWidget> extends BaseState<T> {
  FocusNode focusNode;
  FormUtil formUtil;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  // bool autovalidate = false;

  @override
  void initState() {
    super.initState();
    focusNode = focusNode ?? FocusNode();

    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        setState(() {
          autovalidateMode = AutovalidateMode.onUserInteraction;
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
