import 'package:flutter/material.dart';
import 'package:giv_flutter/util/form/form_field_state.dart';

class PasswordFormField extends StatefulWidget {
  final String labelText;
  final FormFieldValidator<String> validator;
  final bool enabled;
  final FocusNode focusNode;
  final FocusNode nextFocus;
  final TextEditingController controller;

  const PasswordFormField(
      {Key key,
      this.labelText,
      this.validator,
      this.enabled = true,
      this.focusNode,
      this.nextFocus,
      this.controller})
      : super(key: key);

  @override
  _PasswordFormFieldState createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends CustomFormFieldState<PasswordFormField> {
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.focusNode = widget.focusNode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
          labelText: widget.labelText,
          suffixIcon: IconButton(
              icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              })),
      obscureText: _isPasswordVisible,
      keyboardType: TextInputType.text,
      validator: widget.validator,
      autovalidate: autovalidate,
      focusNode: focusNode,
      enabled: widget.enabled,
      onFieldSubmitted: (_) {
        formUtil.passFocus(focusNode, widget.nextFocus);
      },
    );
  }
}
