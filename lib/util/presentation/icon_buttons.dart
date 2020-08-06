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

class ShareIconButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ShareIconButton({Key key, @required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      IconButton(icon: Icon(Icons.share), onPressed: onPressed);
}

class CopyIconButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CopyIconButton({Key key, @required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      IconButton(icon: Icon(Icons.content_copy), onPressed: onPressed);
}

class EditIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;

  const EditIconButton({
    Key key,
    @required this.onPressed,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => IconButton(
        icon: Icon(Icons.edit),
        onPressed: onPressed,
        color: color,
      );
}
