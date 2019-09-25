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
        suffixIcon: PasswordVisibilityToggle(
          icon: _isPasswordVisible ? VisibilityIcon() : VisibilityOffIcon(),
          onPressed: _togglePasswordVisibility,
        ),
      ),
      obscureText: !_isPasswordVisible,
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

  _togglePasswordVisibility() =>
      setState(() => _isPasswordVisible = !_isPasswordVisible);
}

class PasswordVisibilityToggle extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;

  const PasswordVisibilityToggle({
    Key key,
    @required this.icon,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon,
      onPressed: onPressed,
    );
  }
}

class VisibilityIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Icon(Icons.visibility);
}

class VisibilityOffIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Icon(Icons.visibility_off);
}

