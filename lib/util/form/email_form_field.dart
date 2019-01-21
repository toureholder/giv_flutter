import 'package:flutter/material.dart';
import 'package:giv_flutter/util/form/form_field_state.dart';
import 'package:giv_flutter/util/form/validator.dart';

class EmailFormField extends StatefulWidget {
  final bool enabled;
  final FocusNode focusNode;
  final FocusNode nextFocus;
  final TextInputAction textInputAction;
  final TextEditingController controller;

  const EmailFormField(
      {Key key,
      this.enabled = true,
      this.focusNode,
      this.nextFocus,
      this.textInputAction = TextInputAction.next,
      this.controller})
      : super(key: key);

  @override
  _EmailFormFieldState createState() => _EmailFormFieldState();
}

class _EmailFormFieldState extends CustomFormFieldState<EmailFormField> {
  @override
  void initState() {
    super.focusNode = widget.focusNode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(labelText: string('sign_in_form_email')),
      keyboardType: TextInputType.emailAddress,
      validator: Validator(context).email,
      autovalidate: autovalidate,
      focusNode: focusNode,
      textInputAction: widget.textInputAction,
      enabled: widget.enabled,
      onFieldSubmitted: (_) {
        formUtil.passFocus(focusNode, widget.nextFocus);
      },
    );
  }
}
