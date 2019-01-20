import 'package:flutter/material.dart';

class PasswordFormField extends StatefulWidget {
  final String labelText;

  const PasswordFormField({Key key, this.labelText}) : super(key: key);

  @override
  _PasswordFormFieldState createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          labelText: widget.labelText,
          suffixIcon: IconButton(
              icon: Icon(_isPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off),
              onPressed: (){
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              })),
      obscureText: _isPasswordVisible,
      keyboardType: TextInputType.text,
    );
  }
}
