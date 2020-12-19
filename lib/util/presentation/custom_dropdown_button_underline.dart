import 'package:flutter/material.dart';

class CustomDropDownButtonUnderline extends StatelessWidget {
  final bool isError;

  const CustomDropDownButtonUnderline({
    Key key,
    this.isError = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = isError ? Colors.red : Color(0xFFBDBDBD);

    return Container(
      height: 1.0,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: color,
            width: 0.0,
          ),
        ),
      ),
    );
  }
}
