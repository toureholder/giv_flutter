import 'package:flutter/material.dart';

class MoreIconButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MoreIconButton({Key key, @required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      IconButton(icon: Icon(Icons.more_vert), onPressed: onPressed);
}

class BackIconButton extends StatelessWidget {
  final VoidCallback onPressed;

  const BackIconButton({Key key, @required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      IconButton(icon: BackButtonIcon(), onPressed: onPressed);
}
