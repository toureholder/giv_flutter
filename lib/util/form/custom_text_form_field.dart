import 'package:flutter/material.dart';
import 'package:giv_flutter/util/form/form_field_state.dart';

class CustomTextFormField extends StatefulWidget {
  final String labelText;
  final FormFieldValidator<String> validator;
  final bool enabled;
  final FocusNode focusNode;
  final FocusNode nextFocus;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final int maxLength;

  const CustomTextFormField(
      {Key key,
      this.labelText,
      this.validator,
      this.enabled = true,
      this.focusNode,
      this.nextFocus,
      this.textInputAction = TextInputAction.next,
      this.controller,
      this.maxLength})
      : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState
    extends CustomFormFieldState<CustomTextFormField> {
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
      decoration: InputDecoration(labelText: widget.labelText),
      keyboardType: TextInputType.text,
      validator: widget.validator,
      autovalidateMode: autovalidateMode,
      focusNode: focusNode,
      textInputAction: widget.textInputAction,
      enabled: widget.enabled,
      onFieldSubmitted: (_) {
        formUtil.passFocus(focusNode, widget.nextFocus);
      },
      maxLength: widget.maxLength,
    );
  }
}
